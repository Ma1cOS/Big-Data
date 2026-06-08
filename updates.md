# Updates — 2026-06-08

## 1. SMOTE → SMOTENC

**Αρχείο:** `notebooks/preprocessing.ipynb`

**Πρόβλημα:** Το vanilla SMOTE μεταχειριζόταν όλα τα features ως συνεχή, κάνοντας γραμμική παρεμβολή ακόμα και στα categorical indices. Αυτό εισήγαγε ordinal bias (η σειρά του StringIndexer επηρέαζε τις αποστάσεις) και παρήγαγε δεκαδικές τιμές που στρογγυλοποιούνταν μετά, χάνοντας πληροφορία.

**Αλλαγή:** Αντικατάσταση του `SMOTE` με `SMOTENC` (SMOTE for Nominal and Continuous):
- Εισαγωγή: `from imblearn.over_sampling import SMOTENC`
- Κλήση: `SMOTENC(random_state=42, categorical_features=[5,6,7,8,9])`
- Για τις κατηγορικές στήλες χρησιμοποιείται **majority vote** μεταξύ των k-κοντινότερων γειτόνων αντί για γραμμική παρεμβολή
- Το rounding/clipping loop διατηρείται ως μέτρο ασφαλείας

---

## 2. Feature metadata

**Αρχείο:** `notebooks/preprocessing.ipynb` (νέο section 10)

**Πρόβλημα:** Μετά τη μετατροπή σε pandas (για SMOTE) και την επιστροφή σε Spark, τα ML metadata (StringIndexer labels, NominalAttribute) χάνονται. Τα Gold parquet περιέχουν μόνο `features` (SparseVector) + `stroke`, χωρίς καμία πληροφορία για το τι αντιπροσωπεύει κάθε διάσταση.

**Λύση:** Νέο κελί στο τέλος του preprocessing που αποθηκεύει `data/feature_metadata.json` με:
- `feature_dim`: συνολικές διαστάσεις
- `features`: λίστα `{index, column, category?, type}` ανά διάσταση
- `cat_labels`: dict column → list of string labels
- `numeric_cols`, `cat_cols`: λίστες ονομάτων στηλών

---

## 3. Metadata loading στα downstream notebooks

Προστέθηκε βασική δομή (imports + φόρτωση δεδομένων + metadata) στα:
- `notebooks/models.ipynb`
- `notebooks/evaluation.ipynb`
- `notebooks/spark_pipeline.ipynb`
- `notebooks/advanced_technique.ipynb`

Όλα έχουν έτοιμο το `idx_to_label` dict που αντιστοιχίζει feature index → readable όνομα (π.χ. `0 → "gender_Male"`, `16 → "age"`). Χρησιμοποίησέ το όταν τυπώνεις coefficients, feature importance, ή SHAP values.

Επίσης στο `notebooks/eda.ipynb`:
- Προστέθηκε `import json`
- Νέο κελί που φορτώνει το metadata και χτίζει `feat_names`
- Το heatmap του feature vector δείχνει πλέον readable ετικέτες αντί για αριθμούς διαστάσεων
- Το ιστόγραμμα της 1ης διάστασης δείχνει το όνομα του feature στον τίτλο

---

## Πρέπει να ξανατρέξεις

Το **preprocessing notebook** πρέπει να εκτελεστεί από την αρχή για να παραχθούν:
- Τα νέα **parquet** (train_gold, test_gold) με SMOTENC αντί SMOTE
- Το νέο **`data/feature_metadata.json`**

```bash
source venv/bin/activate
jupyter notebook   # άνοιξε notebooks/preprocessing.ipynb → Run All
```

Μετά μπορείς να τρέξεις και το EDA που πλέον φορτώνει το metadata και δείχνει readable feature names.
