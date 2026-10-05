#pragma once

#ifdef ENABLE_TRACE

#include <iostream>
#include <string>
#include <vector>
#include <utility>
#include <type_traits>
#include <cstdio>
#include <cstddef>

namespace trace_logger_internal {

inline void write_json_string(std::ostream& os, const std::string& s) {
    os << '"';
    for (char c : s) {
        switch (c) {
            case '"': os << "\\\""; break;
            case '\\': os << "\\\\"; break;
            case '\b': os << "\\b"; break;
            case '\f': os << "\\f"; break;
            case '\n': os << "\\n"; break;
            case '\r': os << "\\r"; break;
            case '\t': os << "\\t"; break;
            default:
                if (static_cast<unsigned char>(c) < 0x20) {
                    char buf[8];
                    std::snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned char>(c));
                    os << buf;
                } else {
                    os << c;
                }
                break;
        }
    }
    os << '"';
}

inline void write_json_val(std::ostream& os, bool b) {
    os << (b ? "true" : "false");
}

inline void write_json_val(std::ostream& os, char c) {
    write_json_string(os, std::string(1, c));
}

inline void write_json_val(std::ostream& os, const char* s) {
    write_json_string(os, s ? s : "");
}

inline void write_json_val(std::ostream& os, const std::string& s) {
    write_json_string(os, s);
}

template <typename T, typename std::enable_if<std::is_arithmetic<T>::value && !std::is_same<T, bool>::value && !std::is_same<T, char>::value, int>::type = 0>
inline void write_json_val(std::ostream& os, T val) {
    os << val;
}

template <typename A, typename B>
inline void write_json_val(std::ostream& os, const std::pair<A, B>& p);

template <typename T>
inline void write_json_val(std::ostream& os, const std::vector<T>& vec);

template <typename A, typename B>
inline void write_json_val(std::ostream& os, const std::pair<A, B>& p) {
    os << "[";
    write_json_val(os, p.first);
    os << ", ";
    write_json_val(os, p.second);
    os << "]";
}

template <typename T>
inline void write_json_val(std::ostream& os, const std::vector<T>& vec) {
    os << "[";
    for (size_t i = 0; i < vec.size(); ++i) {
        if (i > 0) os << ", ";
        write_json_val(os, vec[i]);
    }
    os << "]";
}

inline void trace_step(long long step_num, const std::string& msg) {
    std::cerr << "[TRACE_JSON]: {\"type\": \"step\", \"step\": " << step_num << ", \"msg\": ";
    write_json_string(std::cerr, msg);
    std::cerr << "}\n";
}

template <typename T>
inline void trace_var(const std::string& name, const T& val) {
    std::cerr << "[TRACE_JSON]: {\"type\": \"var\", \"name\": ";
    write_json_string(std::cerr, name);
    std::cerr << ", \"val\": ";
    write_json_val(std::cerr, val);
    std::cerr << "}\n";
}

template <typename ArrT>
inline void trace_array(const std::string& name, const ArrT& arr, size_t size) {
    std::cerr << "[TRACE_JSON]: {\"type\": \"array\", \"name\": ";
    write_json_string(std::cerr, name);
    std::cerr << ", \"values\": [";
    for (size_t i = 0; i < size; ++i) {
        if (i > 0) std::cerr << ", ";
        write_json_val(std::cerr, arr[i]);
    }
    std::cerr << "]}\n";
}

} // namespace trace_logger_internal

#define TRACE_STEP(step_num, msg) ::trace_logger_internal::trace_step((step_num), (msg))
#define TRACE_VAR(name, val) ::trace_logger_internal::trace_var((name), (val))
#define TRACE_ARRAY(name, arr, size) ::trace_logger_internal::trace_array((name), (arr), (size))
#define LOG_STATE(step, msg) TRACE_STEP((step), (msg))

#else // !ENABLE_TRACE

#define TRACE_STEP(step_num, msg) do {} while (0)
#define TRACE_VAR(name, val) do {} while (0)
#define TRACE_ARRAY(name, arr, size) do {} while (0)
#define LOG_STATE(step, msg) do {} while (0)

#endif // ENABLE_TRACE
