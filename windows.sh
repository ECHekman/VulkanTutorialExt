#!/bin/bash
set -e

exit_on_error()
{
    errcode=$?
    echo "❌ Error $errcode"
    echo "⚠️  The command executing at the time of the error was:"
    echo "$BASH_COMMAND"
    echo "on line ${BASH_LINENO[0]}"
    sleep 5
    exit $errcode
}
trap exit_on_error ERR

pushd .

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Dir = $PROJECT_DIR"

# === vcpkg setup ===
VCPKG_DIR="$HOME/dev/vcpkg"
VCPKG_TOOLCHAIN_FILE="$VCPKG_DIR/scripts/buildsystems/vcpkg.cmake"

if [ ! -d "$VCPKG_DIR" ]; then
    echo "📦 Cloning vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_DIR"
fi

cd "$VCPKG_DIR"

echo "🔧 Bootstrapping vcpkg..."
if [ -f "./bootstrap-vcpkg.sh" ]; then
    ./bootstrap-vcpkg.sh
elif [ -f "./bootstrap-vcpkg.bat" ]; then
    ./bootstrap-vcpkg.bat
fi

echo "📥 Installing glfw3, glm, stb, tinyobjloader..."
./vcpkg install glfw3 stb tinyobjloader --triplet x64-windows

# === back to project and build ===
cd "$PROJECT_DIR"

mkdir -p build/
cd build

echo "🛠️ Running CMake configuration with vcpkg toolchain..."

cmake -G "Visual Studio 17 2022" -A "x64" ../code \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_TOOLCHAIN_FILE" "$@"

popd

echo "✅ Build system is ready."
sleep 5

