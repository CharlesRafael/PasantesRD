# Intern-Bridge - Internship Platform

## 🚀 Quick Start

### What You Need:
- Node.js 
- MySQL 

### Step-by-Step Setup:

1. **Extract the ZIP file**
   - Right-click "Intern_Bridge-Final-Project.zip"
   - Click "Extract All" 
   - Open the extracted folder

2. **Install dependencies**
   - Open Command Prompt/Terminal
   - Navigate to the project folder
   - Type: `npm install` and press Enter

3. **Setup MySQL Database**
   - Install MySQL if not installed
   - Open MySQL
   - Run: `CREATE DATABASE pasantesrd;`

4. **Import Sample Database**
   ```bash
   mysql -u root -p pasantesrd < database_dump.sql

Setup Environment File

Create a new file called .env.local in the project folder

Add these variables (update with your actual MySQL password):

env
DB_PORT=5000 
DB_HOST=localhost
DB_USER=root 
DB_PASSWORD=your_mysql_password_here
DB_NAME=pasantesrd
NEXTAUTH_SECRET=mysecretkey123
NEXTAUTH_URL=http://localhost:3000
Run the Application

In Command Prompt, type: npm run dev

Wait for "Ready" message

Open Browser

Go to: http://localhost:3000

🔑 First-Time Usage
Open http://localhost:3000

Click "Registrarse" to register your first account

Choose account type: Student or Company

Complete registration with real data

Start using the platform

💡 Testing Recommendation
Register with real data (not dummy data) to ensure all pages work correctly

Test both Student and Company flows

Verify all features work as expected
