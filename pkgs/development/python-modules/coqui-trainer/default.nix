{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, pythonAtLeast

, coqpit
, fsspec
, pytorch-bin

, pytestCheckHook
, soundfile
, torchvision-bin
}:

let
  pname = "coqui-trainer";
  version = "0.0.11";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "coqui-ai";
    repo = "Trainer";
    rev = "v${version}";
    hash = "sha256-ujuQ9l6NOpDb2TdQbRcOM+j91RfbE8wCL9C0PID8g8Q=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/coqui-ai/Trainer/commit/07b447abf3290c8f2e5e723687b8a480b7382265.patch";
      sha256 = "0v1hl784d9rghkblcfwgzp0gg9d6r5r0yv2kapzdz2qymiajy7y2";
    })
  ];

  propagatedBuildInputs = [
    coqpit
    fsspec
    pytorch-bin
    soundfile
  ];

  # only one test and that requires training data from the internet
  doCheck = false;

  checkInputs = [
    pytestCheckHook
    torchvision-bin
  ];

  pythonImportsCheck = [
    "trainer"
  ];

  meta = with lib; {
    description = "A general purpose model trainer, as flexible as it gets";
    homepage = "https://github.com/coqui-ai/Trainer";
    license = licenses.asl20;
    maintainers = teams.tts.members;
  };
}
