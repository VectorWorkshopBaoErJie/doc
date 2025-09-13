#!/usr/bin/env python3
"""
将 docs/zh/manuals 目录下的所有 Markdown 文件转换为 Typst 格式并保存到 docs_zh 目录下
使用 pypandoc 库进行转换
"""

import os
import re
import glob
from pathlib import Path
import pypandoc


def convert_md_to_typst(md_content, md_file_path):
    """
    使用 pypandoc 将 Markdown 内容转换为 Typst 格式
    
    参数:
        md_content: Markdown 文件内容
        md_file_path: Markdown 文件路径，用于处理相对路径
        
    返回:
        str: 转换后的 Typst 内容
    """
    # 创建临时文件来保存 Markdown 内容
    temp_md_file = os.path.join(os.path.dirname(md_file_path), "temp.md")
    with open(temp_md_file, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    try:
        # 使用 pypandoc 转换 Markdown 到 Typst
        typst_content = pypandoc.convert_file(
            temp_md_file,
            'typst',
            format='markdown',
            extra_args=['--wrap=preserve']
        )
        
        # 后处理：处理图片路径
        typst_content = process_image_paths(typst_content, md_file_path)
        
        # 处理#link标记
        typst_content = process_link_tags(typst_content)
        
        # 处理#figure转换为#box
        typst_content = process_figure_to_box(typst_content)
        
        # 处理水平分隔线
        typst_content = process_horizontal_rule(typst_content)
        
        return typst_content
    finally:
        # 删除临时文件
        if os.path.exists(temp_md_file):
            os.remove(temp_md_file)


def process_image_paths(content, md_file_path):
    """
    处理图片路径，将其指向正确的位置
    
    参数:
        content: Typst 内容
        md_file_path: 原始 Markdown 文件路径
        
    返回:
        str: 处理后的内容
    """
    # 获取 Markdown 文件所在目录
    md_dir = os.path.dirname(md_file_path)
    
    # 处理图片链接，将相对路径转换为相对于 docs_zh 目录的路径
    def process_image_link(match):
        image_path = match.group(1)
        
        # 如果是绝对路径（以 http:// 或 https:// 开头），则不修改
        if image_path.startswith(('http://', 'https://')):
            return match.group(0)
        
        # 如果路径已经是相对路径到 docs/en/manuals/images，则不修改
        if image_path.startswith('../docs/en/manuals/images/'):
            return match.group(0)
        
        # 如果路径是 images/ 开头的相对路径，则修改为指向 docs/en/manuals/images/
        if image_path.startswith('images/'):
            # 提取 images/ 后面的部分
            image_file = image_path[7:]  # 去掉 "images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            return f'#image("{new_path}")'
        
        # 如果路径是 /images/ 开头的相对路径，也修改为指向 docs/en/manuals/images/
        if image_path.startswith('/images/'):
            # 提取 /images/ 后面的部分
            image_file = image_path[8:]  # 去掉 "/images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            return f'#image("{new_path}")'
        
        # 如果路径是 ../images/ 开头的相对路径，也修改为指向 docs/en/manuals/images/
        if image_path.startswith('../images/'):
            # 提取 ../images/ 后面的部分
            image_file = image_path[10:]  # 去掉 "../images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            return f'#image("{new_path}")'
        
        # 其他情况，保持原路径不变
        return match.group(0)
    
    # 使用正则表达式匹配 Typst 中的图片链接
    # Typst 中的图片格式通常是 #image("path") 或 #box(image("path"))
    content = re.sub(r'#image\("([^"]+)"\)', process_image_link, content)
    
    # 处理 #box(image("path")) 格式
    def process_box_image(match):
        full_match = match.group(0)
        image_path = match.group(1)
        
        # 如果是绝对路径（以 http:// 或 https:// 开头），则不修改
        if image_path.startswith(('http://', 'https://')):
            return full_match
        
        # 如果路径已经是相对路径到 docs/en/manuals/images，则不修改
        if image_path.startswith('../docs/en/manuals/images/'):
            return full_match
        
        # 如果路径是 images/ 开头的相对路径，则修改为指向 docs/en/manuals/images/
        if image_path.startswith('images/'):
            # 提取 images/ 后面的部分
            image_file = image_path[7:]  # 去掉 "images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            # 直接替换路径，保留其他参数
            return full_match.replace(f'image("{image_path}"', f'image("{new_path}"')
        
        # 如果路径是 /images/ 开头的相对路径，也修改为指向 docs/en/manuals/images/
        if image_path.startswith('/images/'):
            # 提取 /images/ 后面的部分
            image_file = image_path[8:]  # 去掉 "/images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            # 直接替换路径，保留其他参数
            return full_match.replace(f'image("{image_path}"', f'image("{new_path}"')
        
        # 如果路径是 ../images/ 开头的相对路径，也修改为指向 docs/en/manuals/images/
        if image_path.startswith('../images/'):
            # 提取 ../images/ 后面的部分
            image_file = image_path[10:]  # 去掉 "../images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            # 直接替换路径，保留其他参数
            return full_match.replace(f'image("{image_path}"', f'image("{new_path}"')
        
        # 其他情况，保持原路径不变
        return full_match
    
    content = re.sub(r'#box\(image\("([^"]+)"[^)]*\)', process_box_image, content)
    
    # 处理 #figure(image("path"), 格式
    def process_figure_image(match):
        full_match = match.group(0)
        image_path = match.group(1)
        
        # 如果是绝对路径（以 http:// 或 https:// 开头），则不修改
        if image_path.startswith(('http://', 'https://')):
            return full_match
        
        # 如果路径已经是相对路径到 docs/en/manuals/images，则不修改
        if image_path.startswith('../docs/en/manuals/images/'):
            return full_match
        
        # 如果路径是 images/ 开头的相对路径，则修改为指向 docs/en/manuals/images/
        if image_path.startswith('images/'):
            # 提取 images/ 后面的部分
            image_file = image_path[7:]  # 去掉 "images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            # 直接替换路径，保留其他参数
            return full_match.replace(f'image("{image_path}"', f'image("{new_path}"')
        
        # 如果路径是 /images/ 开头的相对路径，也修改为指向 docs/en/manuals/images/
        if image_path.startswith('/images/'):
            # 提取 /images/ 后面的部分
            image_file = image_path[8:]  # 去掉 "/images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            # 直接替换路径，保留其他参数
            return full_match.replace(f'image("{image_path}"', f'image("{new_path}"')
        
        # 如果路径是 ../images/ 开头的相对路径，也修改为指向 docs/en/manuals/images/
        if image_path.startswith('../images/'):
            # 提取 ../images/ 后面的部分
            image_file = image_path[10:]  # 去掉 "../images/" 前缀
            new_path = f'../docs/en/manuals/images/{image_file}'
            # 直接替换路径，保留其他参数
            return full_match.replace(f'image("{image_path}"', f'image("{new_path}"')
        
        # 其他情况，保持原路径不变
        return full_match
    
    content = re.sub(r'#figure\(image\("([^"]+)"[^)]*\)', process_figure_image, content)
    
    return content


def process_figure_to_box(content):
    """
    将#figure(image(...), caption: [...])结构转换为#box结构
    
    参数:
        content: Typst 内容
        
    返回:
        str: 处理后的内容
    """
    # 处理 #figure(image("path"), caption: [text]) 格式，转换为 #box(image("path"))
    def process_figure(match):
        full_match = match.group(0)
        image_path = match.group(1)
        
        # 直接返回 #box(image("path")) 格式，去掉 caption 部分
        return f'#box(image("{image_path}"))'
    
    # 使用正则表达式匹配整个 #figure 结构，包括多行 caption
    content = re.sub(r'#figure\(image\("([^"]+)"\),\s*caption:\s*\[[^\]]*\]\s*\)', process_figure, content, flags=re.DOTALL)
    
    return content


def process_link_tags(content):
    """
    处理#link标记，将所有链接转换为纯文本
    
    参数:
        content: Typst 内容
        
    返回:
        str: 处理后的内容
    """
    # 将所有 #link(<...>)[...] 格式的链接转换为纯文本，只保留 [...] 部分
    content = re.sub(r'#link\(<[^>]*>\)\[([^\]]+)\]', r'\1', content)
    
    # 同时处理 #link("...")[...] 格式的链接，也转换为纯文本
    content = re.sub(r'#link\("[^"]*"\)\[([^\]]+)\]', r'\1', content)
    
    # 处理可能由pypandoc转换产生的多余分号
    # 移除链接文本后可能出现的分号
    content = re.sub(r'([^\s])\;(\s*|$)', r'\1\2', content)
    
    return content


def process_horizontal_rule(content):
    """处理水平分隔线，将pypandoc转换后的#horizontalrule替换为Typst的---"""
    # 将pypandoc转换后的#horizontalrule替换为Typst的---
    content = re.sub(r'#horizontalrule', '---', content)
    return content


def convert_md_files_in_directory(source_dir, target_dir):
    """
    将指定目录下的所有 Markdown 文件转换为 Typst 格式并保存到目标目录
    
    参数:
        source_dir: 源目录路径
        target_dir: 目标目录路径
    """
    # 确保目标目录存在
    os.makedirs(target_dir, exist_ok=True)
    
    # 获取所有 Markdown 文件
    md_files = glob.glob(os.path.join(source_dir, "*.md"))
    
    print(f"找到 {len(md_files)} 个 Markdown 文件")
    
    for md_file in md_files:
        # 获取文件名（不含扩展名）
        file_name = os.path.basename(md_file)
        file_name_without_ext = os.path.splitext(file_name)[0]
        
        # 构造目标文件路径
        typst_file = os.path.join(target_dir, file_name_without_ext + ".typ")
        
        print(f"正在转换: {md_file} -> {typst_file}")
        
        # 读取 Markdown 文件内容
        with open(md_file, 'r', encoding='utf-8') as f:
            md_content = f.read()
        
        # 转换为 Typst 格式
        typst_content = convert_md_to_typst(md_content, md_file)
        
        # 写入 Typst 文件
        with open(typst_file, 'w', encoding='utf-8') as f:
            f.write(typst_content)
        
        print(f"转换完成: {typst_file}")
    
    print(f"所有文件转换完成，共转换 {len(md_files)} 个文件")


def main():
    # 设置源目录和目标目录
    base_dir = os.path.dirname(os.path.abspath(__file__))
    source_dir = os.path.join(base_dir, "..", "docs", "zh", "manuals")
    target_dir = os.path.join(base_dir, "..", "docs_zh")
    
    # 转换为绝对路径
    source_dir = os.path.abspath(source_dir)
    target_dir = os.path.abspath(target_dir)
    
    print(f"源目录: {source_dir}")
    print(f"目标目录: {target_dir}")
    
    # 检查源目录是否存在
    if not os.path.exists(source_dir):
        print(f"错误: 源目录不存在: {source_dir}")
        return
    
    # 执行转换
    convert_md_files_in_directory(source_dir, target_dir)


if __name__ == "__main__":
    main()