package com.example.money;

import java.util.Map;

public interface Storable {

    void add(Map<String, Object> arguments);

    void delete(Map<String, Object> arguments);

    void update(String details, Map<String, Object> arguments);

    Object get(String details, Map<String, Object> arguments);
}