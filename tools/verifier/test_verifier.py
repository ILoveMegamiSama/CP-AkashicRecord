import os
import shutil
import subprocess
import json
import pytest

def test_verifier_pipeline(tmp_path):
    # Test file that will fail initially because run_verifier.py and trace_logger.hpp don't exist yet
    src_cpp = tmp_path / "solution.cpp"
    src_cpp.write_text("""#include <iostream>
#include <vector>
#include "trace_logger.hpp"
int main() {
    int n; if (!(std::cin >> n)) return 0;
    long long sum = 0;
    for (int i = 1; i <= n; ++i) {
        sum += i;
        TRACE_STEP(i, "Add i to sum");
        TRACE_VAR("sum", sum);
    }
    std::cout << sum << "\\n";
    return 0;
}
""")
    tests_json = tmp_path / "tests.json"
    tests_data = [{"id": i, "input": f"{i}\\n", "expected": f"{i*(i+1)//2}\\n"} for i in range(1, 11)]
    tests_json.write_text(json.dumps(tests_data))

    out_typst = tmp_path / "table.typ"
    out_web = tmp_path / "web.json"

    res = subprocess.run([
        "python3", "tools/verifier/run_verifier.py",
        "--src", str(src_cpp),
        "--tests", str(tests_json),
        "--out-typst", str(out_typst),
        "--out-web", str(out_web)
    ], capture_output=True, text=True)

    assert res.returncode == 0
    assert out_typst.exists()
    assert out_web.exists()
    web_data = json.loads(out_web.read_text())
    assert len(web_data) == 10
    assert web_data[0]["status"] == "AC"
    assert "traces" in web_data[0]
    typst_content = out_typst.read_text()
    assert "#trace-table" in typst_content

    if shutil.which("typst"):
        dummy_pdf = tmp_path / "table.pdf"
        typst_res = subprocess.run(
            ["typst", "compile", str(out_typst), str(dummy_pdf)],
            capture_output=True,
            text=True,
        )
        assert typst_res.returncode == 0, f"Typst compile error: {typst_res.stderr}"
        assert dummy_pdf.exists()

def test_verifier_wa_detection(tmp_path):
    # Verifier should detect Wrong Answer and exit non-zero
    src_cpp = tmp_path / "buggy.cpp"
    src_cpp.write_text("""#include <iostream>
#include "trace_logger.hpp"
int main() {
    int x; if (std::cin >> x) std::cout << x + 1 << "\\n";
    return 0;
}
""")
    tests_json = tmp_path / "tests.json"
    tests_data = [{"id": 1, "input": "5\\n", "expected": "5\\n"}]
    tests_json.write_text(json.dumps(tests_data))

    out_typst = tmp_path / "table.typ"
    out_web = tmp_path / "web.json"

    res = subprocess.run([
        "python3", "tools/verifier/run_verifier.py",
        "--src", str(src_cpp),
        "--tests", str(tests_json),
        "--out-typst", str(out_typst),
        "--out-web", str(out_web)
    ], capture_output=True, text=True)

    assert res.returncode != 0
    assert out_web.exists()
    web_data = json.loads(out_web.read_text())
    assert web_data[0]["status"] == "WA"

def test_trace_logger_array_and_vars(tmp_path):
    # Verifier with TRACE_ARRAY and TRACE_VAR (including arrays, strings, booleans, and pairs)
    src_cpp = tmp_path / "array_trace.cpp"
    src_cpp.write_text("""#include <iostream>
#include <vector>
#include <utility>
#include "trace_logger.hpp"
int main() {
    int arr[] = {10, 20, 30};
    TRACE_STEP(1, "Initialize array");
    TRACE_ARRAY("arr", arr, 3);
    TRACE_VAR("desc", std::string("test string"));
    TRACE_VAR("flag", true);
    TRACE_VAR("pair", std::make_pair(1, 2));
    std::cout << "done\\n";
    return 0;
}
""")
    tests_json = tmp_path / "tests.json"
    tests_data = [{"id": 1, "input": "\\n", "expected": "done\\n"}]
    tests_json.write_text(json.dumps(tests_data))

    out_typst = tmp_path / "table.typ"
    out_web = tmp_path / "web.json"

    res = subprocess.run([
        "python3", "tools/verifier/run_verifier.py",
        "--src", str(src_cpp),
        "--tests", str(tests_json),
        "--out-typst", str(out_typst),
        "--out-web", str(out_web)
    ], capture_output=True, text=True)

    assert res.returncode == 0
    web_data = json.loads(out_web.read_text())
    traces = web_data[0]["traces"]
    types = [t.get("type") for t in traces]
    assert "step" in types
    assert "array" in types
    assert "var" in types

    if shutil.which("typst"):
        dummy_pdf = tmp_path / "table.pdf"
        typst_res = subprocess.run(
            ["typst", "compile", str(out_typst), str(dummy_pdf)],
            capture_output=True,
            text=True,
        )
        assert typst_res.returncode == 0, f"Typst compilation failed: {typst_res.stderr}"
        assert dummy_pdf.exists()
