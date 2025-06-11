      document.addEventListener('DOMContentLoaded', () => {
        const courseList = document.getElementById('courseList');
        const sectionList = document.getElementById('sectionList');
        const lessonDetail = document.getElementById('lessonDetail');
        const headerTitle = document.getElementById('headerTitle');
        const backToCourses = document.getElementById('backToCourses');
        const backToSections = document.getElementById('backToSections');
        const selectedCourseTitle = document.getElementById('selectedCourseTitle');
        const editLessonBtn = document.getElementById('editLessonBtn');
        const editLessonForm = document.getElementById('editLessonForm');
        const cancelEditLessonBtn = document.getElementById('cancelEditLessonBtn');
        const lessonSearch = document.getElementById('lessonSearch');
        const lessonList = document.getElementById('lessonList');
        const showLessonBtn = document.getElementById('showLessonBtn');
        const showExerciseBtn = document.getElementById('showExerciseBtn');
        const lessonContent = document.getElementById('lessonContent');
        const exerciseSection = document.getElementById('exerciseSection');
        const editExerciseBtn = document.getElementById('editExerciseBtn');
        const editExerciseForm = document.getElementById('editExerciseForm');
        const cancelEditExerciseBtn = document.getElementById('cancelEditExerciseBtn');
        const addLessonForm = document.getElementById('addLessonForm');
        const cancelAddLessonBtn = document.getElementById('cancelAddLessonBtn');

        let currentSection = '';

        // Toggle section visibility
        document.querySelectorAll('.section-header').forEach(header => {
          header.addEventListener('click', () => {
            const sectionId = header.getAttribute('data-section');
            const content = document.getElementById(sectionId);
            const toggleIcon = header.querySelector('.section-toggle i');
            content.classList.toggle('show');
            toggleIcon.classList.toggle('fa-chevron-right', !content.classList.contains('show'));
            toggleIcon.classList.toggle('fa-chevron-down', content.classList.contains('show'));
          });
        });

        // Handle course click
        document.querySelectorAll('.course-card').forEach(card => {
          card.addEventListener('click', () => {
            const courseTitle = card.querySelector('.course-title').textContent;
            courseList.style.display = 'none';
            sectionList.style.display = 'block';
            headerTitle.textContent = `Các Phần - ${courseTitle}`;
            selectedCourseTitle.textContent = courseTitle;
          });
        });

        // Handle section click
        document.querySelectorAll('.section-card').forEach(card => {
          card.addEventListener('click', (e) => {
            if (e.target.classList.contains('add-lesson-btn')) return;
            const sectionTitle = card.querySelector('.section-title').textContent;
            currentSection = sectionTitle.toLowerCase();
            sectionList.style.display = 'none';
            lessonDetail.style.display = 'block';
            headerTitle.textContent = `Bài Học - ${sectionTitle}`;
            selectedCourseTitle.textContent = `${selectedCourseTitle.textContent.split(' - ')[0]} - ${sectionTitle}`;
            showLessonBtn.classList.add('active');
            showExerciseBtn.classList.remove('active');
            lessonContent.style.display = 'block';
            exerciseSection.style.display = 'none';
          });
        });

        // Handle add lesson button
        document.querySelectorAll('.add-lesson-btn').forEach(btn => {
          btn.addEventListener('click', (e) => {
            currentSection = btn.getAttribute('data-section');
            sectionList.style.display = 'block';
            addLessonForm.style.display = 'block';
            lessonDetail.style.display = 'none';
            headerTitle.textContent = `Thêm Bài Học - ${currentSection.charAt(0).toUpperCase() + currentSection.slice(1)}`;
            document.getElementById('addLessonName').value = '';
            document.getElementById('addLessonDescription').value = '';
            document.getElementById('addLessonDuration').value = '';
            document.getElementById('addLessonResource').value = '';
            e.stopPropagation();
          });
        });

        // Handle cancel add lesson
        cancelAddLessonBtn.addEventListener('click', () => {
          addLessonForm.style.display = 'none';
          headerTitle.textContent = `Các Phần - ${selectedCourseTitle.textContent.split(' - ')[0]}`;
        });

        // Handle back to courses
        backToCourses.addEventListener('click', (e) => {
          e.preventDefault();
          courseList.style.display = 'block';
          sectionList.style.display = 'none';
          lessonDetail.style.display = 'none';
          addLessonForm.style.display = 'none';
          headerTitle.textContent = 'Quản Lý Khóa Học';
        });

        // Handle back to sections
        backToSections.addEventListener('click', (e) => {
          e.preventDefault();
          sectionList.style.display = 'block';
          lessonDetail.style.display = 'none';
          headerTitle.textContent = `Các Phần - ${selectedCourseTitle.textContent.split(' - ')[0]}`;
        });

        // Handle show lesson/exercise buttons
        showLessonBtn.addEventListener('click', () => {
          showLessonBtn.classList.add('active');
          showExerciseBtn.classList.remove('active');
          lessonContent.style.display = 'block';
          exerciseSection.style.display = 'none';
          editExerciseForm.style.display = 'none';
          editLessonForm.style.display = 'none';
          editLessonBtn.style.display = 'block';
        });

        showExerciseBtn.addEventListener('click', () => {
          showExerciseBtn.classList.add('active');
          showLessonBtn.classList.remove('active');
          lessonContent.style.display = 'none';
          exerciseSection.style.display = 'block';
          editLessonForm.style.display = 'none';
          editExerciseForm.style.display = 'none';
          editExerciseBtn.style.display = 'block';
        });

        // Handle edit lesson/exercise buttons
        editLessonBtn.addEventListener('click', () => {
          editLessonForm.style.display = 'block';
          editLessonBtn.style.display = 'none';
        });

        cancelEditLessonBtn.addEventListener('click', () => {
          editLessonForm.style.display = 'none';
          editLessonBtn.style.display = 'block';
        });

        editExerciseBtn.addEventListener('click', () => {
          editExerciseForm.style.display = 'block';
          editExerciseBtn.style.display = 'none';
        });

        cancelEditExerciseBtn.addEventListener('click', () => {
          editExerciseForm.style.display = 'none';
          editExerciseBtn.style.display = 'block';
        });

        // Handle lesson search
        lessonSearch.addEventListener('input', () => {
          const searchValue = lessonSearch.value.toLowerCase();
          document.querySelectorAll('.lesson-item').forEach(item => {
            const lessonTitle = item.querySelector('span').textContent.toLowerCase();
            item.style.display = lessonTitle.includes(searchValue) ? 'flex' : 'none';
          });
        });
      });