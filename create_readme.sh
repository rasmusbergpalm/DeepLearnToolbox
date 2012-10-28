echo "" > README.md
cat README_header.md >> README.md

echo -e "Example: Deep Belief Network\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./DBN/dbnexamples.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md

echo -e "Example: Stacked Auto-Encoders\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./SAE/saeexamples.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md

echo -e "Example: Convolutional Neural Nets\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./CNN/cnnexamples.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md

echo -e "Example: Neural Networks\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./NN/nnexamples.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md