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

        // 输入安装链接
        print!("输入安装链接: ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let install_link = check_exit(input.trim());

        input.clear();
        // 输入描述
        print!("输入描述: ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let description = check_exit(input.trim());

        input.clear();
        // 输入依赖
        print!("输入依赖 (不输入默认为None): ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let dependency = if input.trim().is_empty() {
            "None".to_string()
        } else {
            check_exit(input.trim())
        };

        input.clear();
        // 输入是否需要添加到自动化
        print!("是否需要添加到自动化 (1: ✔, 2: ✘, 不输入默认为✘): ");
        io::stdout().flush().expect("刷新输出失败");
        io::stdin().read_line(&mut input).expect("读取失败");
        let automation = if input.trim().is_empty() {
            "✘".to_string()
        } else if input.trim().eq_ignore_ascii_case("1") {
            "✔".to_string()
        } else if input.trim().eq_ignore_ascii_case("2") {
            "✘".to_string()
        } else {
            println!("不受支持的参数，默认设置为 ✘");
            "✘".to_string()
        };

        // 格式化并写入文件
        let row = format!("| {} | {} | {} | {} |\n", install_link, description, dependency, automation);

        if let Err(e) = file.write_all(row.as_bytes()) {
            eprintln!("写入文件失败: {}", e);
        } else {
            println!("数据已写入文件。");
        }
    }
}

fn check_exit(input: &str) -> String {
    if input.eq_ignore_ascii_case("exit") {
        println!("程序退出");
        std::process::exit(0);
    }
    input.to_string()
}

