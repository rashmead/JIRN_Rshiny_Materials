library(here)
library(sodium)

#read in the data from the csv file
user_base = read.csv(here("session5", "examples", "example1_shinyauthr","create_passwords","user_base.csv"))

#hash the passwords
user_base$password = do.call(c,lapply(user_base$password, FUN = sodium::password_store))

#save the hashed version to an RDS file
saveRDS(user_base,  here("session5", "examples", "example1_shinyauthr","create_passwords","user_base.rds") )
