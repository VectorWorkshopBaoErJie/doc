#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import os
import re
from pathlib import Path

def extract_manuals_from_json(json_file):
    """从JSON文件中提取manuals部分的内容"""
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # 由于manuals可能不是根键，我们需要查找它
    # 从已查看的内容看，manuals是data的一个直接属性
    if 'manuals' in data:
        return data['manuals']
    
    # 如果不是直接属性，尝试查找嵌套结构
    def find_manuals(obj):
        if isinstance(obj, dict):
            if 'manuals' in obj:
                return obj['manuals']
            for value in obj.values():
                result = find_manuals(value)
                if result is not None:
                    return result
        elif isinstance(obj, list):
            for item in obj:
                result = find_manuals(item)
                if result is not None:
                    return result
        return None
    
    manuals = find_manuals(data)
    if manuals is None:
        print("错误：在JSON文件中找不到'manuals'部分")
        print(f"JSON文件的根键: {list(data.keys())}")
        return None
    
    return manuals

def get_docs_zh_files(docs_zh_dir, docs_en_manuals_dir):
    """获取docs_zh目录下的所有.typ文件，但只保留在docs/en/manuals目录下有对应md文件的文件"""
    docs_zh_path = Path(docs_zh_dir)
    docs_en_path = Path(docs_en_manuals_dir)
    
    # 获取docs/en/manuals目录下的所有md文件（不带扩展名）
    en_md_files = {f.stem for f in docs_en_path.glob('*.md')}
    
    # 获取docs_zh目录下的所有typ文件（不带扩展名）
    typ_files = []
    excluded_files = []
    
    for f in docs_zh_path.glob('*.typ'):
        filename = f.stem
        # 检查对应的md文件是否存在于docs/en/manuals目录中
        if filename in en_md_files:
            typ_files.append(filename)
        else:
            excluded_files.append(filename)
            print(f"排除文件: {filename}.typ (在docs/en/manuals目录下没有对应的{filename}.md文件)")
    
    if excluded_files:
        print(f"\n总共排除了 {len(excluded_files)} 个文件:")
        for file in excluded_files:
            print(f"  - {file}.typ")
        print(f"保留了 {len(typ_files)} 个文件\n")
    
    return typ_files

def path_to_filename(path):
    """将路径转换为文件名"""
    # 移除路径前缀
    if path.startswith('/manuals/'):
        filename = path[9:]  # 去掉 '/manuals/'
    elif path.startswith('/extension-'):
        # 处理扩展路径，如 /extension-spine#playing-animations
        filename = path[1:]  # 去掉开头的 '/'
        filename = filename.split('#')[0]  # 去掉#后面的部分
    else:
        filename = path[1:] if path.startswith('/') else path
    
    # 处理特殊字符
    filename = filename.replace('-', '_')
    return filename

def generate_include_sequence(manuals, docs_zh_files):
    """生成#include序列"""
    includes = []
    
    for category in manuals:
        category_name = category.get('name', '')
        items = category.get('items', [])
        
        for item in items:
            path = item.get('path', '')
            name = item.get('name', '')
            
            # 跳过非manuals路径（如外部链接）
            if not path.startswith('/manuals/') and not path.startswith('/extension-'):
                continue
                
            # 将路径转换为文件名
            filename = path_to_filename(path)
            
            # 检查文件是否存在于docs_zh目录中
            if filename in docs_zh_files:
                includes.append(f'#include "{filename}.typ"')
            else:
                # 尝试一些常见的变体
                variants = [
                    filename,
                    filename.replace('_', '-'),
                    filename.replace('-', '_'),
                ]
                
                found = False
                for variant in variants:
                    if variant in docs_zh_files:
                        includes.append(f'#include "{variant}.typ"')
                        found = True
                        break
                
                if not found:
                    print(f"警告: 找不到对应的文件 {filename}.typ (路径: {path}, 名称: {name})")
    
    return includes

def main():
    # 设置路径
    json_file = 'g:/Defold_Doc/defold_doc/temp/en.json'
    docs_zh_dir = 'g:/Defold_Doc/defold_doc/docs_zh'
    docs_en_manuals_dir = 'g:/Defold_Doc/defold_doc/docs/en/manuals'
    output_file = 'g:/Defold_Doc/defold_doc/temp/manuals_include.txt'
    
    # 提取manuals数据
    manuals = extract_manuals_from_json(json_file)
    
    # 获取docs_zh文件列表，只保留在docs/en/manuals目录下有对应md文件的文件
    docs_zh_files = get_docs_zh_files(docs_zh_dir, docs_en_manuals_dir)
    
    # 生成include序列
    includes = generate_include_sequence(manuals, docs_zh_files)
    
    # 写入输出文件
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('// 根据en.json中的manuals部分生成的include序列\n')
        f.write('// 只包含在docs/en/manuals目录下有对应md文件的文件\n')
        f.write('// 按照manuals中的顺序排列\n\n')
        for include in includes:
            f.write(include + '\n')
    
    print(f'成功生成include序列，共 {len(includes)} 个文件')
    print(f'输出文件: {output_file}')

if __name__ == '__main__':
    main()