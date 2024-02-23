workspace "Hazel"
	architecture "x64"
	
	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Cherno_Hazel"
	location "Cherno_Hazel"
	kind "SharedLib"
	language "C++"
	
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	include 
	{
		"%{prj.name}/vendor/spdlog/include;"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines 
		{
			"HZ_PLATFORM_WINDOWS",
			"HZ_BUILD_DLL",
		}


		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
		}


	filter "configurations:Debug"
		define "HZ_DEBUG"
		symbols "On"

	filter "configurations:Release"
		define "HZ_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		define "HZ_DIST"
		optimize "On"


project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	include 
	{
		"%{prj.name}/vendor/spdlog/include"
		"Hazel/src"
	}

	links
	{
		"Cherno_Hazel"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines 
		{
			"HZ_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		define "HZ_DEBUG"
		symbols "On"

	filter "configurations:Release"
		define "HZ_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		define "HZ_DIST"
		optimize "On"