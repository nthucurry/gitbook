src_storage_account_name="1storageauo"
src_container_name="i-mfg"
src_aad_name="2fa430c4-fd7e-4dfe-996c-46fc2cda44f8"
src_SAS_token="sp=r&st=2021-08-05T14:24:05Z&se=2021-08-05T22:24:05Z&spr=https&sv=2020-08-04&sr=c&sig=dRaGIxPmG0j35TFtItadowVdxT6LB1AKkfNDmQEs7wY%3D"
dst_storage_account_name="datainterchange"
dst_container_name="i-mfg"
dst_aad_name="e7c24d00-7479-4343-8247-0204699693e8"
dst_SAS_token="?sv=2020-08-04&ss=bfqt&srt=c&sp=rwdlacuptfx&se=2021-08-05T22:33:37Z&st=2021-08-05T14:33:37Z&spr=https&sig=e3XJuGVkM9NPJ7QPRCBStL3q7zqSycjc0ehEaRKf9LM%3D"

azcopy sync \
"https://$src_storage_account_name.blob.core.windows.net/$src_container_name?$src_SAS_token" \
"https://$dst_storage_account_name.blob.core.windows.net/$dst_container_name?$dst_SAS_token" \
--recursive

echo "\
azcopy sync \
"https://$src_storage_account_name.blob.core.windows.net/$src_container_name?$src_SAS_token" \
"https://$dst_storage_account_name.blob.core.windows.net/$dst_container_name?$dst_SAS_token" \
--recursive\
"