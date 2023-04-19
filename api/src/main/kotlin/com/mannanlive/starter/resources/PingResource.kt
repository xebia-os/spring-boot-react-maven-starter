package com.mannanlive.starter.resources

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class PingResource {
    @GetMapping(path = ["/ping"])
    fun ping(): ResponseEntity<Map<String, String>> {
        val map: MutableMap<String, String> = HashMap()
        map["ping"] = "pong"
        return ResponseEntity(map, HttpStatus.OK)
    }
}
