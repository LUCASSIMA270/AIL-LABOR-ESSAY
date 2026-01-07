#library(arrow)
library(foreign)

list_post_db <- c("post_2022_1_0", "post_2022_2_0", "post_2022_3_0", "post_2022_4_0", "post_2022_5_0", "post_2022_6_0", "post_2022_7_0", "post_2022_8_0",
                  "post_2022_9_AZ_0", "post_2022_9_BE_0", "post_2022_9_FZ_0", "post_2022_9_GI_0", "post_2022_9_JU_0", "post_2022_9_OQ_0", "post_2022_NA_0", 
                  "post_2021_1_0", "post_2021_2_0", "post_2021_3_0", "post_2021_4_0", "post_2021_5_0", "post_2021_6_0", "post_2021_7_0", "post_2021_8_0",
                  "post_2021_9_AZ_0", "post_2021_9_BE_0", "post_2021_9_FZ_0", "post_2021_9_GI_0", "post_2021_9_JU_0", "post_2021_9_OQ_0", "post_2021_NA_0")
for (post_db in list_post_db) {
  print(post_db)
  toexport <- arrow::read_parquet(sprintf("//casd.fr/casdfs/Projets/AUTOTRA/Data/DADS_DADS Postes_2022/%s.parquet",post_db))
  print("Step 1 done")
  toexport <- toexport[, c("ident_s", "siren", "siret", "apet", "pcs", "filt", "duree", "ind_3112", 
                         "eff_3112_et", "comt", "domempl", "regt", "sexe", "annee_naiss",
                         "s_brut", "eqtp", "nbheur", "datfin")]
  print("Step 2 done")  
  write.dta(toexport,sprintf("C:/Users/Public/Documents/replication_abjmrs_aeapp/data/dads/%s.dta",post_db))
  print("Step 3 done")  
}
