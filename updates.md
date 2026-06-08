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

**Πρόβλημα:** Μετά τη μετατροπή σε pandas (για SMOTE) και την επιστροφή σε Spark, τα ML metadata (StringIndexer labels, NominalAttribute) χάνονται. Τα Gold parquet περιέχουν μόνο `features` (SparseVector 21d) + `stroke`, χωρίς καμία πληροφορία για το τι αντιπροσωπεύει κάθε διάσταση.

**Λύση:** Νέο κελί στο τέλος του preprocessing που αποθηκεύει `data/feature_metadata.json`:

```json
{
  "feature_dim": 21,
  "features": [
    {"index": 0,  "column": "gender",         "category": "Male",             "type": "onehot"},
    {"index": 1,  "column": "gender",         "category": "Female",           "type": "onehot"},
    {"index": 2,  "column": "ever_married",   "category": "No",               "type": "onehot"},
    ...
    {"index": 15, "column": "smoking_status", "category": "formerly smoked",  "type": "onehot"},
    {"index": 16, "column": "age",            "type": "numeric"},
    {"index": 17, "column": "hypertension",   "type": "numeric"},
    {"index": 18, "column": "heart_disease",  "type": "numeric"},
    {"index": 19, "column": "avg_glucose_level", "type": "numeric"},
    {"index": 20, "column": "bmi",            "type": "numeric"}
  ],
  "cat_labels": { "gender": [...], "ever_married": [...], ... },
  "numeric_cols": ["age", "hypertension", "heart_disease", "avg_glucose_level", "bmi"],
  "cat_cols": ["gender", "ever_married", "work_type", "Residence_type", "smoking_status"]
}
```

Το αρχείο φορτώνεται από τα υπόλοιπα notebooks με `json.load()` για χρήση σε feature importance, coefficients και explainability.
