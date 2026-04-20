# Mozart409 Zola Blog

A personal blog built with [Zola](https://www.getzola.org/), a fast static site generator written in Rust.

## 🌐 Live Site

**[https://blog.mozart409.com](https://blog.mozart409.com)**

## 🛠️ Tech Stack

- **[Zola](https://www.getzola.org/)** - Static site generator
- **[TailwindCSS v4](https://tailwindcss.com/)** - Utility-first CSS framework
- **[Nix](https://nixos.org/)** - Reproducible development environment
- **[Just](https://just.systems/)** - Task runner
- **[Cocogitto](https://github.com/cocogitto/cocogitto)** - Conventional commits
- **[Lefthook](https://github.com/evilmartians/lefthook)** - Git hooks manager

## 📁 Project Structure

```
.
├── blog/                  # Zola site directory
│   ├── content/          # Markdown blog posts
│   ├── static/           # Static assets (CSS, images)
│   ├── templates/        # HTML templates
│   ├── themes/           # Zola themes
│   └── zola.toml         # Zola configuration
├── flake.nix             # Nix development environment
├── justfile              # Task definitions
├── lefthook.yml          # Git hooks configuration
└── .envrc                # direnv configuration
```

## 🚀 Getting Started

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- [direnv](https://direnv.net/) (optional, for automatic environment activation)

### Development Environment

The project uses Nix flakes to provide a reproducible development environment. All dependencies (Zola, TailwindCSS, Just, etc.) are automatically managed.

```bash
# Enter the development shell
nix develop

# Or if using direnv, allow the environment
direnv allow
```

### Available Commands

| Command | Description |
|---------|-------------|
| `just` | List all available tasks |
| `just dev` | Start Zola development server |
| `just css` | Build and minify CSS once |
| `just css-watch` | Watch CSS files and rebuild on changes |

## 📝 Creating Content

Blog posts are written in Markdown and placed in the `blog/content/` directory. Each post should include front matter:

```markdown
+++
title = "Your Post Title"
date = 2026-04-21
+++

Your content here...
```

## 🎨 Styling

CSS is built using TailwindCSS. The input file is at `blog/static/input.css` and the output is `blog/static/app.css`.

## 🔄 Git Workflow

The project uses:
- **Cocogitto** for conventional commits (`feat:`, `fix:`, `docs:`, etc.)
- **Lefthook** to run checks before commits

## 📄 License

This project is open source. See the repository for license details.

---

Built with ❤️ using Zola and Nix
