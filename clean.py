#!/usr/bin/env python3
import os
import shutil
import subprocess

workspace_dir = os.getcwd()
build_dir = os.path.join(workspace_dir, "build")

def clean_build_directory():
    # Run cmake --build to clean the build
    subprocess.run(["cmake", "--build", build_dir, "--target", "clean"], check=True)
    # Remove solution in build directory, except .gitignore file
    for root, dirs, files in os.walk(build_dir):
        for name in files:
            os.remove(os.path.join(root, name))
        for name in dirs:
            shutil.rmtree(os.path.join(root, name))
    print("Solution succesfully cleaned!")

if __name__ == "__main__":
    try:
        clean_build_directory()
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while cleaning the build directory: {e}")
        exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        exit(1)