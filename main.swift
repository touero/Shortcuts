import Foundation

let arguments = CommandLine.arguments
let currentDir = FileManager.default.currentDirectoryPath
let readmeURL = URL(fileURLWithPath: currentDir).appendingPathComponent("README.md")

if arguments.count == 2 {
    let argument = arguments[1]
    if argument == "--help" || argument == "-h" {
        print("-v or --version: 查看当前版本")
        print("-h or --help: 查看帮助")
        print("-r or --remove: 删除某一行")
        exit(0)
    } else if argument == "--version" || argument == "-v"{
        print("Version 0.0.1")
        exit(0)
    } else if argument == "--remove" || argument == "-r"{
        removeLine(readmeURL: readmeURL)
        exit(0)
    }
}

func removeLine(readmeURL: URL){
    do {
        let fileContents = try String(contentsOf: readmeURL, encoding: .utf8)
        var lines = fileContents.split(separator: "\n").map { String($0) }
        let lineToShow = lines.dropFirst(4)
        for (index, line) in lineToShow.enumerated() {
            print("\(index + 5): \(line)")
        }
        print("请输入删除的行号: ", terminator: "")
        if let input = readLine(), let lineToRemove = Int(input), lineToRemove >= 5, lineToRemove <= lines.count{
            let indexToRemove = lineToRemove - 1
            lines.remove(at: indexToRemove)
            let newContent = lines.joined(separator: "\n")
            try newContent.write(to: readmeURL, atomically: true, encoding: .utf8)
            print("行 \(lineToRemove) 已成功删除")
        } else {
            print("无效行号或输入, 程序退出")
        }
    } catch {
        print("读取文件失败: \(error)")
        exit(1)
    }
}

print("输入表格数据, 每次按提示输入, 按顺序输入以下内容: 1.输入名称, 2. 安装链接, 3. 描述, 4. 依赖, 5. 是否需要添加到自动化, 输入 'exit' 或者 'quit' 退出程序.\n")
struct LineWritten {
    var name: String = ""
    var installUrl: String = ""
    var description: String = ""
    var dependency: String = "None"
    var isAddAuto: String = "✘"

    func writeFile() {
        let line = "| [\(name)](\(installUrl)) | \(description) | \(dependency) | \(isAddAuto) |\n"
        do {
            let fileHandle = try FileHandle(forWritingTo: readmeURL)
            fileHandle.seekToEndOfFile()
            guard let data = line.data(using: .utf8) else {
                print("Failed to encode the line into data.")
                exit(0)
            }
            fileHandle.write(data)
            fileHandle.closeFile()
            print("write to README.md success, you can continue or exit")
        } catch {
            print("write to README.md failed with error: \(error)")
            exit(0)
        }
    }
}

func checkExit(input: String) {
    if input == "exit" || input == "quit" {
        print("\n程序退出");
        exit(0)
    }
}

while true {
    var lineWritten = LineWritten()
        print("1. 输入名称: ", terminator:"")
    if let input = readLine(), !input.isEmpty {
        checkExit(input: input)
        lineWritten.name = input
    } else {
        print("名称为空")
        continue
    }
    print("2. 输入安装链接: ", terminator:"")
    if let input = readLine(), !input.isEmpty {
        checkExit(input: input)
        lineWritten.installUrl = input
    } else {
        print("安装链接为空")
        continue
    }
    print("3. 输入描述: ", terminator:"")
    if let input = readLine(), !input.isEmpty {
        checkExit(input: input)
        lineWritten.description = input
    } else {
        print("描述为空")
        continue

    }
    print("4. 输入依赖 (不输入默认为None): ", terminator:"")
    if let input = readLine(), !input.isEmpty {
        lineWritten.dependency = String(input)
    }
    print("5. 是否需要添加到自动化 (1: ✔, 2: ✘, 不输入默认为✘): ", terminator:"")
    if let input = readLine(), !input.isEmpty {
        var result: String
        if input == "1" {
            result = "✔"
        } else if input == "2" {
            result = "✘"
        } else {
            print("不受支持的参数，默认设置为 ✘");
            result = "✘"
        }
        lineWritten.isAddAuto = result
    }
    lineWritten.writeFile()
}
