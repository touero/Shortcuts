import Foundation

let currentDir = FileManager.default.currentDirectoryPath
let readmeURL = URL(fileURLWithPath: currentDir).appendingPathComponent("README.md")


do {
    let fileContents = try String(contentsOf: readmeURL, encoding: .utf8)
    print("\(fileContents)\n")
} catch {
    print("读取文件失败: \(error)")
    exit(1)
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
