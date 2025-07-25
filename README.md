
<h2>#Description</h2>
The To-Do Web App is a Flutter-based productivity application designed to manage tasks efficiently with an intuitive Kanban-style board layout. It supports <strong>real-time updates using Firebase Realtime Database</strong>, ensuring your tasks are always synced. The app is responsive, theme-aware (Light/Dark Mode), and leverages modern Flutter state management for clean and scalable architecture.

<h2>Features 🚀</h2>
<ul>
  <li><strong>Real-time Task Management:</strong> Create, edit, delete, and move tasks between boards with instant updates using Firebase Realtime Database.</li>
  <li><strong>Dark and Light Mode:</strong> Toggle between dark and light themes seamlessly with persistent preferences.</li>
  <li><strong>Kanban Board Layout:</strong> Organised task categorisation (To Do, In Progress, Completed) with drag-and-drop functionality.</li>
  <li><strong>Task Prioritisation:</strong> Assign High, Medium, or Low priority with colour-coded indicators.</li>
  <li><strong>Smooth Performance:</strong> Built with Flutter Riverpod for efficient state management.</li>
</ul>

<h2>Built With 🛠️</h2>
<ul>
  <li><strong>Flutter:</strong> Cross-platform UI toolkit for app development.</li>
  <li><strong>appflowy_board:</strong> For Kanban board implementation.</li>
  <li><strong>flutter_riverpod:</strong> State management.</li>
  <li><strong>firebase_core & firebase_database:</strong> Backend for real-time task storage and sync.</li>
  <li><strong>shared_preferences:</strong> Persistent storage for theme mode preferences.</li>
  <li><strong>date_field:</strong> For task date selections.</li>
  <li><strong>flutter_screenutil:</strong> Responsive UI across different screen sizes.</li>
  <li><strong>intl:</strong> Date formatting and localisation.</li>
  <li><strong>shimmer:</strong> Loading placeholders for improved UX.</li>
  <li><strong>cupertino_icons:</strong> iOS style icons.</li>
</ul>

<h2>Dependencies 📦</h2>
<pre>
cupertino_icons: ^1.0.8
appflowy_board: ^0.1.2
riverpod: ^2.6.1
flutter_riverpod: ^2.6.1
date_field: ^6.0.3+1
flutter_screenutil: ^5.9.3
firebase_core: ^3.15.2
firebase_database: ^11.3.10
shared_preferences: ^2.5.3
intl: ^0.20.2
shimmer: ^3.0.0
</pre>

<h2>Screenshots 📸</h2>
<p>Add your screenshots here after uploading to GitHub:</p>

<img width="800" height="500" alt="To Do Home Page" src="https://github.com/user-attachments/assets/388bc129-6045-4982-a66b-21c5bc044cf6" />
<img width="800" height="500"  alt="Add Task" src="https://github.com/user-attachments/assets/7ba92689-9a83-4868-81b0-f3c0243c7f0a" />
<img width="800" height="500"  alt="Completed Task" src="https://github.com/user-attachments/assets/1bff922d-8d48-40ab-8c70-6375fd5f26a2" />
<img width="800" height="500"  src="https://github.com/user-attachments/assets/a098dc33-d81a-4945-9112-f3f4727c1be2" alt="Theme">


<h2>Setup Instructions ⚙️</h2>
<ul>
  <li><strong>Clone the repository:</strong></li>
</ul>

<pre>
git clone https://github.com/your-username/to-do-web-app.git
cd to-do-web-app
</pre>

<ul>
  <li><strong>Install dependencies:</strong></li>
</ul>

<pre>
flutter pub get
</pre>

<ul>
  <li><strong>Setup Firebase:</strong></li>
</ul>

<p>
Follow official <a href="https://firebase.flutter.dev/docs/overview/">FlutterFire documentation</a> to configure your Firebase project.
Add your <code>google-services.json</code> (Android) or <code>GoogleService-Info.plist</code> (iOS/MacOS) accordingly.
</p>

<ul>
  <li><strong>Run the app:</strong></li>
</ul>

<pre>
flutter run -d chrome
# or for desktop
flutter run -d macos
</pre>

<h2>Project Structure Highlights 📁</h2>
<ul>
  <li><strong>core/</strong> – App constants, colours, and shared widgets.</li>
  <li><strong>feature/</strong> – Feature-wise separation (task board, sidebar, settings).</li>
  <li><strong>providers/</strong> – Riverpod providers for theme, tasks, and settings.</li>
</ul>

