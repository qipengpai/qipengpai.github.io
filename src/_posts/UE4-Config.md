---
title: UE4 Config配置文件的使用
date: 2020-11-17 08:54:11
categories: UE4
tags: [UE4, Config]
comments: false
---

本篇文章将简单介绍UE4 项目开发过程中, 如何使用配置文件来修改项目中的参数

<p id="div-border-left-green">我们知道在UE4项目的根目录下都会有一个 Config 的文件夹,里面有各种.ini 结尾的文件,这里面都是UE4 默认生成的一些配置文件. 今天我们要做的就是使用自己定义的.ini 文件,定义自己的 Config 变量, 并用这些变量来初始化 Class 中的定义的成员变量.</p>


#### 1.关于打包后Config文件的位置
如果采用Development 或者DebugGame 模式打包的话, Config 文件会生成在 `打包目录\项目名称\Saved\Config\WindowsNoEditor` 目录中, 但是如果用Shipping 模式打包的话, 会发现找不到这个目录了, 那么在Windows 系统下 我们可以在如下地址找到 `C:\Users\用户名\AppData\Local\项目名称\Saved\Config\WindowsNoEditor`.
接下来也会把我们自己的 Config 文件生成在指定的目录下,方便找到和修改.

#### 2. 把成员变量设置为可用Config 配置
在UE4 c++ Class 变量的宏定义中, 加入 `config` 关键字
``` C++
	// 是否作为服务器启动
	UPROPERTY(config ,Category="CustomIni")
	bool bServer=false;
```
<!-- more -->
#### 3. 定义 Config 目录
在类的构造函数中可以定义 自己的 Config 目录, 这里定义为项目目录下的 Settings 文件夹, 配置文件的名称是 Custom.ini
``` c++
ConfigPath = FPaths::ProjectDir() / TEXT("Settings/Custom.ini");
```


#### 4. 加载和保存 Config 配置

定义两个函数:
``` c++
void UMyGameInstance::LoadCustomConfig()
{
	GConfig->Flush(true, ConfigPath);
	ReloadConfig(this->GetClass(), *ConfigPath);
}

void UMyGameInstance::SaveCustomConfig()
{
	SaveConfig(CPF_Config, *ConfigPath);
	GConfig->Flush(false, ConfigPath);
}

```
首先在 void UMyGameInstance::Init() 中调用SaveCustomConfig();  (Actor 类可以在 BeginPlay  中 ) 

``` c++
void UMyGameInstance::Init()
{
	Super::Init();

	bServer = true; // bServer 默认为false, 而SaveCustomConfig() 函数只会把和默认值不一致的变量存入 Custom.ini中,所以此处先修改一下
	SaveCustomConfig();
}
```
这里调用 SaveCustomConfig()  的目的是为了在 `项目目录/Settings` 下生成 一个 Custom.ini.
Custom.ini 里面的 内容如下 `我为了测试方便是在蓝图中调用的` :
```
[/Game/Blueprints/GameControl/BP_PTGameInstance.BP_PTGameInstance_C]
bServer=true
```
然后把保存的函数注释掉, 只保留加载函数:

``` c++
void UMyGameInstance::Init()
{
	Super::Init();

	// bServer = true;
	// SaveCustomConfig();

	LoadCustomConfig();
}
```
这里调用 LoadCustomConfig() 的目的是为了把 UMyGameInstance 中 bServer 这个变量的值设置为 Custom.ini 中的值. 名称是一一对应的.

这个就实现了, 无论是Development, Debug模式,还是Shipping 模式打包的项目, 都可以在 `项目目录/Settings`  下面设置 Custom.ini 中的变量, 设置的变量的值就会被设置为对应的变量的值.
对于同一个项目,需要不同自定义配置来启动的话,这将是一个很方面的方式.