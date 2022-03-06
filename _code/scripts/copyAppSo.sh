#!/bin/bash

p_path='C:/Users/imkim/StudioProjects/sumgo-crawller-flutter/_code'
echo "$p_path"
cd $p_path

echo "flutter build windows"
flutter build windows

echo "$p_path/scripts"
cd $p_path/scripts

echo "cp -r ../build/windows/app.so ../build/windows/runner/Debug/data"
cp -r ../build/windows/app.so ../build/windows/runner/Debug/data