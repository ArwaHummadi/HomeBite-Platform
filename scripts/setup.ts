// Prepares the project on a new computer with one command: npm run setup
// 1. creates the .env file, 2. starts the database in Docker,
// 3. creates the tables, 4. adds the starting data (cities and settings).
import { execSync, spawnSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";

const root = path.resolve(__dirname, "..");

// Runs a command and shows its output. Stops the setup if the command fails.
function run(command: string) {
  console.log(`\n> ${command}`);
  execSync(command, { stdio: "inherit", cwd: root });
}

// Waits for the given number of milliseconds.
function wait(ms: number) {
  Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms);
}

// 1. The .env file
const envFile = path.join(root, ".env");
if (!fs.existsSync(envFile)) {
  fs.copyFileSync(path.join(root, ".env.example"), envFile);
  console.log("Created .env from .env.example");
}

// 2. The database. Docker Desktop must be open.
const docker = spawnSync("docker", ["info"], { stdio: "ignore" });
if (docker.status !== 0) {
  console.log("\nDocker is not running. Open Docker Desktop, wait until it says it is running, then run npm run setup again.");
  process.exit(1);
}
run("docker compose up -d db");

process.stdout.write("\nWaiting for the database ");
let ready = false;
for (let i = 0; i < 60 && !ready; i++) {
  const check = spawnSync(
    "docker",
    ["compose", "exec", "-T", "db", "pg_isready", "-h", "127.0.0.1", "-U", "homebite", "-d", "homebite"],
    { cwd: root, stdio: "ignore" },
  );
  ready = check.status === 0;
  if (!ready) {
    process.stdout.write(".");
    wait(1000);
  }
}
if (!ready) {
  console.log("\nThe database did not start. Check Docker Desktop and try again.");
  process.exit(1);
}
console.log(" ready");

// 3. The tables, from the files in prisma/migrations
run("npx prisma migrate deploy");

// 4. The starting data
run("npx tsx prisma/seed.ts");

console.log("\nDone. Start the website with: npm run dev");
