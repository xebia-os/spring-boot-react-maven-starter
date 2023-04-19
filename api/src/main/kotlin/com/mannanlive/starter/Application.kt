package com.mannanlive.starter

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@Suppress("UtilityClassWithPublicConstructor")
@SpringBootApplication
class Application {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            @Suppress("SpreadOperator")
            runApplication<Application>(*args)
        }
    }
}
