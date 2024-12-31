use std::fs::OpenOptions;
use std::io::{self, Write};

fn main() {
    let file_name = "README.md";

    let mut file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(file_name)
        .expect("无法打开文件");

    println!("输入表格数据, 每次按提示输入, 按顺序输入以下内容: 1. 安装链接, 2. 描述, 3. 依赖, 4. 是否需要添加到自动化, 输入 'exit' 退出程序.\n");

    loop {
        let mut input = String::new();

        print!("输入安装链接: ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let install_link = check_exit(input.trim());

        input.clear();
        print!("输入描述: ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let description = check_exit(input.trim());

        input.clear();
        print!("输入依赖 (不输入默认为None): ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let dependency = if input.trim().is_empty() {
            "None".to_string()
        } else {
            check_exit(input.trim())
        };

        input.clear();
        print!("是否需要添加到自动化 (输入 ✅ 或 ❌, 不输入默认为✅): ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let automation = if input.trim().is_empty() {
            "✅".to_string()
        } else {
            check_exit(input.trim())
        };

        let row = format!(
            "| {} | {} | {} | {} |\n",
           install_link, description, dependency, automation
        );

        if let Err(e) = file.write_all(row.as_bytes()) {
            eprintln!("写入文件失败: {}", e);
        } else {
            println!("数据已写入文件。");
        }
    }
}

fn check_exit(input: &str) -> String {
    if input.eq_ignore_ascii_case("exit") {
        println!("程序立即");
        std::process::exit(0);
    }
    input.to_string()
}

