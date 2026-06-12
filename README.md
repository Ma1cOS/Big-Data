# Stroke Prediction — Big Data Project

> Εξαμηνιαία Εργασία — Big Data & Data Mining

## Γρήγορη Εκκίνηση

```bash
git clone https://github.com/Ma1cOS/Big-Data.git
cd Big-Data
python3.12 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Εκτέλεση

```bash
source venv/bin/activate
jupyter notebook
```

### Σειρά εκτέλεσης notebooks

```
1. notebooks/preprocessing.ipynb    # Παράγει Silver + Gold Parquet στο data/
2. notebooks/eda.ipynb              # Οπτικοποιήσεις από Silver Layer
3. notebooks/models.ipynb           # Μοντέλα classification
4. notebooks/spark_pipeline.ipynb   # Spark ML Pipeline
5. notebooks/advanced_technique.ipynb
6. notebooks/evaluation.ipynb       # Αξιολόγηση & σύγκριση
```

Η σειρά είναι **αυστηρά σειριακή**. Το preprocessing πρέπει να τρέξει πρώτα — παράγει τα Parquet αρχεία που χρειάζονται τα υπόλοιπα notebooks.

## Δεδομένα

Το `healthcare-dataset-stroke-data.csv` βρίσκεται στο root του repo.

Το preprocessing παράγει αυτόματα 4 Parquet αρχεία στον φάκελο `data/`:

| Αρχείο | Περιγραφή |
|--------|-----------|
| `train_silver.parquet` | Train set μετά indexing (readable labels) |
| `test_silver.parquet` | Test set μετά indexing |
| `train_gold.parquet` | Train set μετά one-hot + scaling + SMOTE |
| `test_gold.parquet` | Test set μετά one-hot + scaling |

Τα αρχεία γράφονται με `mode("overwrite")` σε κάθε εκτέλεση.
