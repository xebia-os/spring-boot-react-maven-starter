package com.example.app.resources;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

public class PingResourceTests extends AbstractRestApiTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void should_return_pong_when_get_request_is_made_to_ping() throws Exception {
        mockMvc.perform(get("/api/ping"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.ping").value(equalTo("pong")));
    }
}
