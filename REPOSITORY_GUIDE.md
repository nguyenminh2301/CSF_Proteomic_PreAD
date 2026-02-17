# Repository Guide

## 🎉 Tổ chức Repository Hoàn Tất

Repository đã được tổ chức lại để sẵn sàng cho GitHub. Dưới đây là hướng dẫn sử dụng.

## 📂 Cấu Trúc Thư Mục

```
MANUSCRIPT/Manu_3/
├── .github/                    # GitHub templates (hiện tại trống)
├── archive/                    # File cũ/không dùng nữa
│   ├── old_docs/              # Tài liệu cũ
│   ├── old_figures/           # Figures phiên bản cũ
│   └── old_manuscripts/       # Bản thảo cũ
├── data/                       # Dữ liệu
│   ├── processed/             # Kết quả xử lý (được track)
│   └── raw/                   # Dữ liệu gốc (KHÔNG track)
├── figures/                    # Figures
│   ├── main/                  # Figures chính (Fig1, Fig2)
│   └── supplementary/         # Figures phụ (FigS1-S4)
├── manuscript/                 # Bản thảo
│   └── manuscript.md          # Bản thảo chính (Ver2)
├── R/                          # R scripts
│   ├── 01_main_analysis.R     # Phân tích chính
│   ├── 02_figures.R           # Tạo figures
│   ├── 03_tables.R            # Tạo tables
│   └── 04_sensitivity_analysis.R
├── tables/                     # Bảng kết quả
│   ├── Table1_baseline_characteristics.{csv,md}
│   ├── Table2_model_results.{csv,md}
│   ├── SupplementaryTableS1_top_proteins.{csv,md}
│   └── SupplementaryTableS2_pathway_enrichment.{csv,md}
├── .gitignore                  # Quy tắc ignore
├── CITATION.cff                # File trích dẫn
├── LICENSE                     # Giấy phép MIT
├── README.md                   # README chính
└── REPOSITORY_GUIDE.md         # File này
```

## ⚡ Các Thay Đổi Chính

### 1. Files Đã Di Chuyển

| File Cũ | Vị Trí Mới |
|---------|-----------|
| `R_Scrip/*.R` | `R/*.R` |
| `Outputs/*_lancet.*` | `figures/main/` và `figures/supplementary/` |
| `Tables/*` | `tables/` |
| `Manuscript/FINAL-MANUSCRIPT_Ver2.md` | `manuscript/manuscript.md` |
| `Manuscript/Ver1, FILL_IN_VALUES` | `archive/old_manuscripts/` |
| `Outputs/*.{png,tiff}` (cũ) | `archive/old_figures/` |

### 2. Files Đã Đổi Tên

| Tên Cũ | Tên Mới |
|--------|---------|
| `R_manu3.R` | `01_main_analysis.R` |
| `figures_lancet.R` | `02_figures.R` |
| `tables_q1.R` | `03_tables.R` |
| `01_sensitivity_analysis.R` | `04_sensitivity_analysis.R` |
| `Fig1_combined_lancet.*` | `figures/main/Fig1.*` |
| `Fig2_pathway_enrichment_lancet.*` | `figures/main/Fig2.*` |
| `FigS1_cooks_distance_lancet.*` | `figures/supplementary/FigS2_cooks_distance.*` |
| `FigS2_sensitivity_analysis_lancet.*` | `figures/supplementary/FigS4_sensitivity.*` |

### 3. Cập Nhật Đường Dẫn

Tất cả các file R scripts đã được cập nhật đường dẫn:
- **Input**: `data/processed/` (thay vì `Outputs/`)
- **Output data**: `data/processed/`
- **Output figures**: `figures/main/` và `figures/supplementary/`
- **Output tables**: `tables/`

## 🔒 Bảo Mật

### GitIgnore Bảo Vệ

File `.gitignore` đã cấu hình để KHÔNG track:
- ✅ `data/raw/` - Dữ liệu gốc PREVENT-AD
- ✅ Files lớn (>100MB)
- ✅ API keys và credentials
- ✅ Temporary files
- ✅ OS-specific files

### Nội Dung Được Bảo Vệ

Không commit các file sau:
```
data/raw/CONP*.csv
data/raw/RBANS.csv
data/raw/PET_*.csv
data/raw/CSF_SomaScan*.csv
.env
*.key
```

## 🚀 Sử Dụng Repository

### Chạy Phân Tích

```r
# Set working directory
setwd("path/to/Manu_3")

# Chạy pipeline
source("R/01_main_analysis.R")  # Tạo processed data
source("R/02_figures.R")         # Tạo figures
source("R/03_tables.R")          # Tạo tables
```

### Thêm Vào Git

```bash
cd Manu_3

# Khởi tạo git (nếu chưa có)
git init

# Thêm remote
git remote add origin https://github.com/username/repo.git

# Add files
git add .
git commit -m "Initial commit: organized repository"

# Push
git push -u origin main
```

## ⚠️ Lưu Ý Quan Trọng

1. **KHÔNG** commit dữ liệu raw PREVENT-AD
2. **KHÔNG** commit API keys hoặc credentials
3. **LUÔN** kiểm tra `.gitignore` trước khi commit
4. **GIỮ NGUYÊN** cấu trúc thư mục để scripts chạy đúng

## 📊 Thống Kê

- **Tổng files**: 62
- **Tổng dung lượng**: 34.18 MB
- **Files code R**: 4
- **Figures**: 21 (3 main + 18 supplementary variants)
- **Tables**: 9
- **Data processed**: 5 CSV files

## 📞 Hỗ Trợ

Nếu có vấn đề với cấu trúc repository, kiểm tra:
1. Đường dẫn trong R scripts có đúng không
2. Các thư mục cần thiết đã tồn tại chưa
3. File `.gitignore` có đang block file cần thiết không

---

**Ngày tổ chức**: 2025-02-17  
**Version**: 1.0.0
