# Chuyển đổi từ EJN Short Communication sang Molecular Neurobiology Brief Report

## Tóm tắt các điều chỉnh cần thực hiện

### 1. Thay đổi chính

| Thành phần | EJN Short Communication | Molecular Neurobiology Brief Report | Hành động |
|------------|------------------------|-------------------------------------|-----------|
| **Word limit** | 3,500 words | Không cụ thể (~2,000-3,500) | Giữ nguyên ~1,842 words ✓ |
| **Abstract** | 150 words | 150-250 words | Mở rộng abstract nếu cần |
| **Keywords** | Không nêu rõ | 4-6 keywords | Thêm 4-6 keywords |
| **Citation** | Author-Year (Hamilton et al., 2025) | Numbered [1], [2-5] | **Đổi toàn bộ citations** |
| **ORCID** | Placeholder OK | Bắt buộc | Thêm ORCID thật |
| **Statements** | Basic | Chi tiết hơn | Thêm các statements |
| **Supplementary** | Không cho phép | Cho phép | Có thể thêm nếu cần |

### 2. Cấu trúc Manuscript cần điều chỉnh

#### Title Page
**EJN hiện tại:**
```
Running Head: CSF Proteomic Correlates of Cognitive Resilience (47 chars)
Title: CSF Proteomic Correlates of Cognitive Resilience in Preclinical Alzheimer Disease
Authors: [Tên tác giả]
Affiliations: [Cơ quan]
Corresponding Author: [email]
Word Count: [X,XXX words]
```

**Molecular Neurobiology yêu cầu:**
```
Title: [Giữ nguyên]
Authors: [Tên tác giả]
Affiliations: Institution, Department, City, State, Country
Corresponding Author: Active email address
ORCID: 16-digit ID (bắt buộc)
Acknowledgments: [Funding đầy đủ]
```

#### Abstract
- EJN: ~150 words (đang OK)
- Molecular Neurobiology: 150-250 words → **Có thể mở rộng thêm**

#### Keywords
- **THÊM MỚI**: 4-6 keywords (EJN không yêu cầu)
- Gợi ý: CSF proteomics, cognitive resilience, Alzheimer disease, preclinical AD, SOMAscan, MEF2C

#### Main Text
- Giữ nguyên nội dung
- Điều chỉnh headings nếu cần (tối đa 3 cấp)

### 3. Chuyển đổi Citations (QUAN TRỌNG)

Từ **Author-Year** sang **Numbered [x]**

**Ví dụ:**
```
EJN: "Recent studies (Hamilton et al., 2025; Tijms et al., 2024) suggest..."
Molecular Neurobiology: "Recent studies [1,2] suggest..."

EJN: "According to Shen et al. (2024), CSF proteomics..."
Molecular Neurobiology: "According to Shen et al. [3], CSF proteomics..."
```

### 4. References Format (QUAN TRỌNG)

Từ:
```
Hamilton SE, Oh H, Urey DY, et al. (2025) CSF synaptic protein biomarker 
for cognitive resilience to Alzheimer disease pathology. Nature Medicine, 31(5):1592–1603.
```

Sang:
```
Hamilton SE, Oh H, Urey DY et al (2025) CSF synaptic protein biomarker for 
cognitive resilience to Alzheimer disease pathology. Nat Med 31(5):1592–1603. 
https://doi.org/xx.xxxx/xxxxx
```

**Lưu ý:**
- Bỏ dấu chấm sau journal name
- Thêm DOI đầy đủ
- Dùng "et al" thay vì "et al." (không có dấu chấm)
- Journal abbreviation theo ISSN LTWA

### 5. Statements & Declarations (THÊM MỚI)

Sau References, thêm section:

```markdown
## Statements and Declarations

### Funding
This work was supported by [Grant Agency] (Grant number [XXXX]). 
[Hoặc: The authors declare that no funds, grants, or other support were received 
during the preparation of this manuscript.]

### Competing Interests
The authors have no relevant financial or non-financial interests to disclose.

### Author Contributions
All authors contributed to the study conception and design. Material preparation, 
data collection and analysis were performed by [Name], [Name]. The first draft of 
the manuscript was written by [Name] and all authors commented on previous versions. 
All authors read and approved the final manuscript.

### Data Availability
The datasets generated during and/or analysed during the current study are available 
in the [Repository Name] repository, [PERSISTENT LINK].

### Ethics Approval
This study was performed in line with the principles of the Declaration of Helsinki. 
Approval was granted by the [Ethics Committee Name] (Date: [XX/XX/XXXX]/No: [XXXX]).

### Consent to Participate
Informed consent was obtained from all individual participants included in the study.

### Consent to Publish
Not applicable. [Hoặc: The authors affirm that human research participants provided 
informed consent for publication of [specific content].]
```

### 6. Figures & Tables

**Giữ nguyên như EJN:**
- 4 figures
- 2 tables

**Điều chỉnh figure captions:**
```
EJN: "Figure 1. Diagnostic metrics..."
Molecular Neurobiology: "**Fig. 1** Diagnostic metrics..." (Fig. in bold)
```

### 7. Kiểm tra cuối cùng

#### Submission Checklist:
- [ ] Chuyển đổi tất cả citations sang numbered format [x]
- [ ] Cập nhật references sang Molecular Neurobiology format
- [ ] Thêm ORCID cho corresponding author
- [ ] Thêm 4-6 keywords
- [ ] Thêm Statements & Declarations section
- [ ] Điều chỉnh figure captions (Fig. in bold)
- [ ] Kiểm tra DOIs trong references
- [ ] Format file: .docx hoặc .doc

#### Files cần nộp:
- [ ] Manuscript chính (.docx)
- [ ] Figures riêng (EPS/TIFF/PDF)
- [ ] Cover letter
- [ ] Optional: Supplementary Information

---

## Những điểm thuận lợi khi chuyển sang Molecular Neurobiology

1. **Brief Report phù hợp**: Dữ liệu hiện tại (n=27) là small-scale study → phù hợp định nghĩa Brief Report
2. **Supplementary cho phép**: Có thể bổ sung data bổ sung nếu cần
3. **Abstract dài hơn**: Có thể mở rộng thêm thông tin
4. **Không giới hạn figures/tables**: Thoải mái hơn EJN (max 4 figures, 2 tables)

## Những điểm cần lưu ý

1. **ORCID bắt buộc**: Phải có trước khi submit
2. **Statements & Declarations**: Nhiều yêu cầu hơn EJN
3. **Citation format**: Cần chuyển đổi toàn bộ từ Author-Year sang Numbered
4. **DOIs**: Bắt buộc cho tất cả references nếu có

---

*Chuẩn bị bởi: AI Assistant*  
*Ngày: 2026-02-17*
