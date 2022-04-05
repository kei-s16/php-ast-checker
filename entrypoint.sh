#!/bin/bash

git fetch origin $1 >> /dev/null

diff_php_files=`git diff --name-only HEAD origin/$1 -- | grep -E '*.php$'`

if [[ -z $diff_php_files ]]; then
	exit
fi

for file in ${diff_php_files[@]}
do
	echo -ne "AST Result\nFile: ${file} \n \`\`\` \n" > /tmp/ast_result
	php src/ast.php $file >> /tmp/ast_result
	echo -ne "\n \`\`\` \n" >> /tmp/ast_result

	cat /tmp/ast_result

	gh pr comment -F /tmp/ast_result "${URL}"
	
	# ast_result=`php src/ast.php $file | \
	# 	sed -e "s/\"/\\\u0022/g" | \
	# 	sed -e "s./.\\\u002F.g" | \
	# 	sed -e "s/[\]/\\\u005C/g" | \
	# 	sed -e "s/\s\{4\}/\\\u0009/g" | \
	# 	sed -e "s/$/  \n/g"`

	# echo -E $ast_result

	# curl -X POST \
	# 	-H "Accept: application/vnd.github.v3+json" \
	# 	-H "Authorization: token ${GITHUB_TOKEN}" \
	# 	-d "{\"body\":\"AST Result\nFile: $(echo -n $file) \n --- \n $(echo -E $ast_result) \"}" \
	# 	${URL}
done
