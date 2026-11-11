use std::path::PathBuf;

use sevenz_rust2::ArchiveWriter;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut args = std::env::args_os().skip(1).map(PathBuf::from);
    let source = args.next().ok_or("usage: archiver <source-directory> <archive.7z>")?;
    let output = args.next().ok_or("usage: archiver <source-directory> <archive.7z>")?;
    if args.next().is_some() || !source.is_dir() || output.exists() {
        return Err("usage: archiver <source-directory> <new-archive.7z>".into());
    }
    if walk_has_link(&source)? {
        return Err("the staged runtime contains a symbolic link".into());
    }
    let mut writer = ArchiveWriter::create(&output)?;
    writer.push_source_path(&source, |_| true)?;
    writer.finish()?;
    Ok(())
}

fn walk_has_link(path: &std::path::Path) -> Result<bool, std::io::Error> {
    let metadata = std::fs::symlink_metadata(path)?;
    if metadata.file_type().is_symlink() {
        return Ok(true);
    }
    if metadata.is_dir() {
        for child in std::fs::read_dir(path)? {
            if walk_has_link(&child?.path())? {
                return Ok(true);
            }
        }
    }
    Ok(false)
}
