import Foundation

let currentDir = FileManager.default.currentDirectoryPath
let readmePath = currentDir + "/README.md"
print(readmePath)

do {
    let fileContents = try String(contentsOfFile: readmePath, encoding: .utf8)
    print(fileContents)
} catch {
    print("读取文件失败: \(error)")
}
