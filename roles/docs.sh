for file in */; do
  serviceName=${file%?}
  mv ../docs_software/$serviceName.md $serviceName/docs.md
done
