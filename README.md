# Manual File Reputation Demo

A PowerShell 7 command that computes a file's SHA-256 hash and compares it with a small local fixture. It demonstrates careful error handling and explicit data boundaries in a manual file-checking workflow.

## Run on Windows PowerShell 7

From this repository, run:

```powershell
./scripts/get-file-reputation.ps1 -FilePath ./examples/sample.txt
./tests/get-file-reputation.tests.ps1
```

The sample should match the fixture. Other files normally return `No local fixture match`. A missing match is **not** evidence that a file is safe.

## Safety and scope

The command never uploads a file, sends its hash to a service, writes a log, or changes Windows settings. The output contains a file hash but omits the local path. The fixture is synthetic and has no malware intelligence. Only run it on files you are authorized to inspect. Shell integration and real reputation services require a separate design and review.
