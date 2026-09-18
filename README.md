# نظام إدارة المهام | Task Management System

## نبذة عن المشروع
نظام إدارة المهام هو مشروع تطبيق موبايل تم تطويره باستخدام Flutter بهدف دعم إدارة المشاريع والمهام بطريقة منظمة وفعالة. يتيح النظام للمستخدمين إضافة المهام، تعيين الأولوية، تحديد تاريخ الاستحقاق، ومتابعة تقدم المشروع بشكل بصري وسهل. كما يركز المشروع على توضيح مفهوم الخوارزميات المستخدمة في تنظيم البيانات وحساب ساعات المشروع بطريقة علمية وتحليلية.

يُعد هذا المشروع مثالاً عملياً على الدمج بين تصميم واجهات المستخدم وتطبيق خوارزميات الحوسبة، حيث يتم عرض أداء خوارزميات الفرز ومقارنة كفاءتها، بالإضافة إلى حساب إجمالي ساعات المشروع باستخدام أسلوب التقسيم والتغلب (Divide and Conquer) والتكرار (Recursion).

## بيانات المشروع
- المشرف: أ. أحمد الصالح
- الطلاب:
  - عبدالرحمن العم
  - نزيه الحمود
  - ايهم كريد
  - يحيى عقيل هاشم قناص

## أهداف المشروع
- تصميم نظام سهل الاستخدام لإدارة المهام والمشاريع.
- تنظيم المهام حسب الأولوية وتاريخ التسليم.
- مقارنة أداء خوارزميات الفرز اليدوية بشكل عادل.
- عرض تحليل الوقت المعقد (Time Complexity) لكل خوارزمية.
- حساب إجمالي ساعات المشروع بشكل متكرر باستخدام شجرة المهام الفرعية.
- توضيح مفهوم الخوارزميات في تطبيق عملي واقعي.

## مميزات النظام
- إضافة المهام مع اسمها ووصفها وساعاتها وتاريخ الاستحقاق.
- ترتيب المهام حسب الأولوية: عالية، متوسطة، منخفضة.
- ترتيب المهام حسب تاريخ الاستحقاق من الأقدم إلى الأحدث.
- قياس الوقت المنفذ لكل خوارزمية فرز.
- مقارنة بين Merge Sort و Quick Sort على نفس البيانات.
- عرض شجرة المشروع والمهام الفرعية بشكل مرئي.
- حساب إجمالي ساعات المشروع باستخدام دالة تكرارية.
- تحليل أداء الخوارزميات بشكل مبسط وواضح في الواجهة.

## الخوارزميات المستخدمة

### 1) Merge Sort
خوارزمية فرز تقسم البيانات إلى أجزاء صغيرة ثم تدمجها بشكل منظم. تستخدم هذه الخوارزمية في المشروع لفرز المهام وفقاً للأولوية أو تاريخ الاستحقاق.

- التعقيد الزمني: O(n log n)
- أفضل حالة: O(n log n)
- متوسط الحالة: O(n log n)
- أسوأ حالة: O(n log n)

### 2) Quick Sort
خوارزمية فرز تعتمد على اختيار عنصر محوري وتقسيم البيانات إلى جزأين ثم فرز كل جزء بشكل مستقل. يتم استخدام Pivot كآخر عنصر في القائمة.

- التعقيد الزمني: O(n log n) في المتوسط
- أسوأ حالة: O(n²)

### 3) Divide and Conquer / Recursion
يتم التعامل مع المشروع كجذر يحتوي على شجرة من المهام الفرعية. تستدعي الدالة العودية كل فرع، ثم تجمع النتائج لتحديد إجمالي الساعات المتوقع للمشروع.

- التعقيد الزمني: O(n)
- تعقيد مساحة الذاكرة: O(h) حيث h هو عمق الشجرة

## ماذا يظهر في واجهة المستخدم؟
- فرز المهام حسب الأولوية.
- فرز المهام حسب تاريخ الاستحقاق.
- وقت تنفيذ جميع عمليات الفرز.
- مقارنة عادلة بين Merge Sort و Quick Sort.
- عرض جذع المشروع وعمق المهام الفرعية.
- إجمالي ساعات المشروع.
- خطوات استدعاءات الدوال العودية (Recursive Call Stack).
- تحليل الخوارزميات وأفضل/متوسط/أسوأ الحالات.

## قواعد التنفيذ المهمة
- لا يتم استخدام أي دالة فرز مدمجة في Dart مثل sort().
- يتم تنفيذ الخوارزميات يدوياً داخل مجلد `lib/algorithms/`.
- يتم استخدام نفس البيانات الأولية لكل خوارزمية عند المقارنة لضمان عدالة الاختبار.

## المتطلبات
- Flutter SDK
- Dart SDK
- IDE مثل VS Code أو Android Studio

## التشغيل
1. قم بتنزيل المستودع.
2. نفذ الأمر التالي:

```bash
flutter pub get
```

3. ثم قم بتشغيل التطبيق:

```bash
flutter run
```

4. لاختبارات المشروع:

```bash
flutter test
```

## الخلاصة
هذا المشروع يجمع بين إدارة المشاريع وحل المشكلات الحسابية باستخدام الخوارزميات. وهو ليس مجرد تطبيق لإدارة المهام، بل أيضًا نموذج عملي يوضح كيفية تطبيق المفاهيم الأساسية في علم الحاسوب مثل الفرز، التكرار، وتقسيم المشكلات إلى أجزاء أصغر بطريقة ذكية وفعالة.

إن تنفيذ المشروع على منصة Flutter يضيف بعداً بصرياً وعملياً، ويجعل من السهل فهم الكيفية التي تعمل بها الخوارزميات داخل تطبيق حقيقي، وهو ما يجعل المشروع مناسباً كعرض عملي في مجال البرمجة وهندسة البرمجيات.

---

## Project Overview (English)
This project is a Flutter-based Task Management System designed to help users organize projects and tasks in a simple and effective way. It allows the user to add tasks, assign priorities, set deadlines, and track the overall progress of a project. In addition, the app demonstrates important algorithmic concepts such as sorting and divide-and-conquer recursion.

The project compares manual Merge Sort and Quick Sort on the same unsorted data, evaluates execution time, and calculates the total project hours recursively based on the task tree structure. This makes the app a practical example of how data structures and algorithms can be applied in a real-world application.

## Team Members
- Supervisor: Dr. Ahmad Al-Saleh
- Students:
  - Abdulrahman Al-Am
  - Nazeeh Al-Hamoud
  - Ayyham Kareed
  - Yahya Aqeel Hashem Qanass

## Features
- Task creation and management
- Priority-based sorting
- Due-date sorting
- Time comparison of sorting algorithms
- Recursive project hour calculation
- Visual project structure and task tree
- Complexity analysis for each algorithm

## Run Instructions
```bash
flutter pub get
flutter run
flutter test
```

## Final Note
This project combines software engineering, visual interface design, and algorithmic thinking in one practical system. It highlights how a simple task manager can become a valuable educational tool for understanding sorting algorithms and recursive problem-solving.
