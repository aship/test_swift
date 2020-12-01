//
//  CharacterPhysics.swift
//  TestSwift
//
//  Created by aship on 2020/11/30.
//

import SceneKit

extension Character {
    // MARK: - physics contact
    func slideInWorld(fromPosition start: SIMD3<Float>, velocity: SIMD3<Float>) {
        let maxSlideIteration: Int = 4
        var iteration = 0
        var stop: Bool = false

        var replacementPoint = start

        var start = start
        var velocity = velocity
        let options: [SCNPhysicsWorld.TestOption: Any] = [
            SCNPhysicsWorld.TestOption.collisionBitMask: Bitmask.collision.rawValue,
            SCNPhysicsWorld.TestOption.searchMode: SCNPhysicsWorld.TestSearchMode.closest]
        while !stop {
            var from = matrix_identity_float4x4
            from.position = start

            var to: matrix_float4x4 = matrix_identity_float4x4
            to.position = start + velocity

            let contacts = physicsWorld!.convexSweepTest(
                with: characterCollisionShape!,
                from: SCNMatrix4(from),
                to: SCNMatrix4(to),
                options: options)
            if !contacts.isEmpty {
                (velocity, start) = handleSlidingAtContact(contacts.first!, position: start, velocity: velocity)
                iteration += 1

                if simd_length_squared(velocity) <= (10E-3 * 10E-3) || iteration >= maxSlideIteration {
                    replacementPoint = start
                    stop = true
                }
            } else {
                replacementPoint = start + velocity
                stop = true
            }
        }
        characterNode!.simdWorldPosition = replacementPoint - collisionShapeOffsetFromModel
    }

    func handleSlidingAtContact(_ closestContact: SCNPhysicsContact, position start: SIMD3<Float>, velocity: SIMD3<Float>)
        -> (computedVelocity: simd_float3, colliderPositionAtContact: simd_float3) {
        let originalDistance: Float = simd_length(velocity)

        let colliderPositionAtContact = start + Float(closestContact.sweepTestFraction) * velocity

        // Compute the sliding plane.
        let slidePlaneNormal = SIMD3<Float>(closestContact.contactNormal)
        let slidePlaneOrigin = SIMD3<Float>(closestContact.contactPoint)
        let centerOffset = slidePlaneOrigin - colliderPositionAtContact

        // Compute destination relative to the point of contact.
        let destinationPoint = slidePlaneOrigin + velocity

        // We now project the destination point onto the sliding plane.
        let distPlane = simd_dot(slidePlaneOrigin, slidePlaneNormal)

        // Project on plane.
        var t = planeIntersect(planeNormal: slidePlaneNormal, planeDist: distPlane,
                               rayOrigin: destinationPoint, rayDirection: slidePlaneNormal)

        let normalizedVelocity = velocity * (1.0 / originalDistance)
        let angle = simd_dot(slidePlaneNormal, normalizedVelocity)

        var frictionCoeff: Float = 0.3
        if abs(angle) < 0.9 {
            t += 10E-3
            frictionCoeff = 1.0
        }
        let newDestinationPoint = (destinationPoint + t * slidePlaneNormal) - centerOffset

        // Advance start position to nearest point without collision.
        let computedVelocity = frictionCoeff * Float(1.0 - closestContact.sweepTestFraction)
            * originalDistance * simd_normalize(newDestinationPoint - start)

        return (computedVelocity, colliderPositionAtContact)
    }
}
