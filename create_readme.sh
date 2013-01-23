echo "" > README.md
cat README_header.md >> README.md

echo -e "Example: Deep Belief Network\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./tests/test_example_DBN.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md

echo -e "Example: Stacked Auto-Encoders\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./tests/test_example_SAE.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md

echo -e "Example: Convolutional Neural Nets\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./tests/test_example_CNN.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md

echo -e "Example: Neural Networks\n---------------------\n\`\`\`matlab\n" >> README.md
cat ./tests/test_example_NN.m >> README.md
echo -e "\n\`\`\`\n\n" >> README.md