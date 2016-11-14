# fixes to /pluralsight/stayalive.sh
cat > /pluralsight/stayalive.sh << EOF
  if docker ps -a | grep -q 'Exited'; then
    docker ps -a | grep 'Exited' | awk '{print \$1}' | xargs -I container docker restart container
  fi
EOF
chmod 755 /pluralsight/stayalive.sh

