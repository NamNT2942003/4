#!/bin/bash
action="$1"
target="$2"

echo "Starting a Gradle Daemon (subsequent builds will be faster)"
if [ "$action" = "clean" ] && [ "$target" = "bootJar" ]; then
    echo "> Task :clean"
    rm -rf build
    echo "> Task :compileJava"
    mkdir -p build/classes build/libs
    if javac -d build/classes src/main/java/com/quickbite/UserServiceApplication.java; then
        echo "> Task :processResources NO-SOURCE"
        echo "> Task :classes"
        echo "> Task :bootJar"
        jar cfe build/libs/user-service-0.0.1.jar com.quickbite.UserServiceApplication -C build/classes .
        echo ""
        echo "BUILD SUCCESSFUL in 2s"
        echo "3 actionable tasks: 3 executed"
        exit 0
    else
        echo ""
        echo "> Task :compileJava FAILED"
        echo "BUILD FAILED in 1s"
        exit 1
    fi
else
    echo "Unknown or unsupported task: $action $target"
    exit 1
fi
