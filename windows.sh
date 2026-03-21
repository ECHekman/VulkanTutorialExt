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

# === vcpkg setup ===
VCPKG_DIR="$HOME/dev/vcpkg"              # You can customize this
VCPKG_TOOLCHAIN_FILE="$VCPKG_DIR/scripts/buildsystems/vcpkg.cmake"

# Clone vcpkg if missing
if [ ! -d "$VCPKG_DIR" ]; then
    echo "📦 Cloning vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_DIR"
fi

# Bootstrap vcpkg if needed
cd "$VCPKG_DIR"
echo "$VCPKG_DIR"
if [ ! -f "./vcpkg.exe" ]; then
    echo "🔧 Bootstrapping vcpkg..."
    ./bootstrap-vcpkg.bat
fi

# Install required packages
echo "📥 Installing glfw3, glm, stb, volk, tinyobjloader..."
./vcpkg install glfw3 glm stb volk tinyobjloader vulkan-memory-allocator --triplet x64-windows

# === back to project and build ===
cd "$OLDPWD"

mkdir -p build/
cd build

# Configure with Visual Studio and vcpkg toolchain
echo "🛠️  Running CMake configuration with vcpkg toolchain..."
cmake -G "Visual Studio 17 2022" -A "x64" ../code \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_TOOLCHAIN_FILE" "$@"

popd

echo "✅ Build system is ready. You can now build the solution in Visual Studio or with cmake --build build"
sleep 5
