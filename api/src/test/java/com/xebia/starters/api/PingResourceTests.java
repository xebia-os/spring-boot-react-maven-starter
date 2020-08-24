package com.xebia.starters.api;

import org.junit.Test;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

public class PingResourceTests extends AbstractRestApiTest {

    @Test
    public void should_return_pong_when_get_request_is_made_to_ping() throws Exception {
        mockMvc.perform(get("/ping"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.ping").value(equalTo("pong")));
    }
}
