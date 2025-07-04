# FYI to see decluttered tree use:
tree -I "node_modules|.git|.DS_Store|*.log|coverage|build|dist|tmp"
# Show all models with filenames as headers:
for file in app/models/*.rb; do echo "=== $file ==="; cat "$file"; echo; done

# Show all controllers.rb with filenames as headers:
for file in app/controllers/*.rb; do echo "=== $file ==="; cat "$file"; echo; done

# For all views in folders A–R
for file in app/views/[a-r]*/*.html.erb; do echo "=== $file ==="; cat "$file"; echo; done

# For all views in folders S–Z
for file in app/views/[s-z]*/*.html.erb; do echo "=== $file ==="; cat "$file"; echo; done

# See the helpers
for file in app/helpers/*.rb; do echo "=== $file ==="; cat "$file"; echo; done
# Check the routes to understand the flow
echo "=== config/routes.rb ==="; cat config/routes.rb; echo
# See the logic classes for recovery tracking
for file in app/logic/*.rb; do echo "=== $file ==="; cat "$file"; echo; done

# Show all js controllers with filenames as headers:
for file in app/javascript/controllers/**/[a-i]*_controller.js; do echo "=== $file ==="; cat "$file"; echo; done

for file in app/javascript/controllers/**/[j-z]*_controller.js; do echo "=== $file ==="; cat "$file"; echo; done

# For all CSS files in stylesheets/pages
for file in app/assets/stylesheets/pages/*.css; do echo "=== $file ==="; cat "$file"; echo; done
# For all CSS files in stylesheets/Themes
for file in app/assets/stylesheets/themes/*.css; do echo "=== $file ==="; cat "$file"; echo; done
# For all CSS files in stylesheets/Components A–C
for file in app/assets/stylesheets/components/[a-c]*.css; do echo "=== $file ==="; cat "$file"; echo; done
# For all CSS files in stylesheets/Components D–Z
for file in app/assets/stylesheets/components/[d-z]*.css; do echo "=== $file ==="; cat "$file"; echo; done



# 🚀 FEATURE BRANCH WORKFLOW
# Replace 'feature-name' with your actual feature (e.g., 'add-rest-timer', 'fix-mobile-ui')


# 1️⃣ CREATE & SWITCH TO NEW BRANCH
git checkout -b feature-name


# 2️⃣ DO YOUR WORK
# - Make changes in VS Code
# - Test locally: rails server (visit localhost:3000)
# - Make sure everything works as expected

# 3️⃣ COMMIT YOUR CHANGES
git add .
git commit -m "Add feature: brief description of what you built"

# 4️⃣ PUSH BRANCH TO GITHUB
git push origin feature-name

# 5️⃣ MERGE TO MAIN
git checkout main
git merge feature-name

# 6️⃣ PUSH MAIN TO GITHUB
git push origin main

# 7️⃣ DEPLOY TO HEROKU
git push heroku main

# 8️⃣ TEST LIVE APP
# Visit https://heavy-duty-1bf635cff355.herokuapp.com/
# Make sure your feature works in production

# 9️⃣ CLEANUP - DELETE BRANCH
git branch -d feature-name                    # Delete local branch
git push origin --delete feature-name        # Delete remote branch

# 🔄 READY FOR NEXT FEATURE!
# git checkout -b next-feature-name

# 📝 QUICK REFERENCE
# Check current branch:
git branch
# See all branches:
git branch -a
# Switch branches:
git checkout branch-name
# Check status:
git status
# test a feature on Heroku before merging to main:
git push heroku feature-name:main
