package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class VersionController {
    @Value("${git.tags}")
    private String version;

    @Value("${git.commit.id}")
    private String commitId;

    @RequestMapping("/version")
    public Map<String, String> getCommitId() {
        Map<String, String> result = new HashMap<>();
        result.put("Version", version);
        result.put("Commit id", commitId);
        return result;
    }
}
