/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */



      // Pagination and filtering logic
      const rowsPerPage = 10;
      let currentPage = 1;
      let filteredRows = [];

      // Get all rows
      const allRows = Array.from(document.querySelectorAll('#courseTableBody tr'));

      // Initialize pagination
      function updatePagination() {
        const totalRows = filteredRows.length || allRows.length;
        const totalPages = Math.ceil(totalRows / rowsPerPage);
        currentPage = Math.max(1, Math.min(currentPage, totalPages));

        // Show/hide rows based on current page
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;

        allRows.forEach(row => row.style.display = 'none');
        (filteredRows.length ? filteredRows : allRows).slice(start, end).forEach(row => row.style.display = '');

        // Update pagination info
        document.getElementById('pageInfo').textContent = `Trang ${currentPage} / ${totalPages}`;

        // Enable/disable buttons
        document.getElementById('prevPage').disabled = currentPage === 1;
        document.getElementById('nextPage').disabled = currentPage === totalPages;
      }

      // Filter logic
      document.querySelectorAll('#teacherFilter, #levelFilter, #statusFilter, #createdDateFilter, #nameSearch').forEach(filter => {
        filter.addEventListener('change', applyFilters);
        filter.addEventListener('input', applyFilters);
      });

      function applyFilters() {
        const teacher = document.getElementById('teacherFilter').value.toLowerCase();
        const level = document.getElementById('levelFilter').value.toLowerCase();
        const status = document.getElementById('statusFilter').value.toLowerCase();
        const createdDate = document.getElementById('createdDateFilter').value;
        const nameSearch = document.getElementById('nameSearch').value.toLowerCase();

        filteredRows = allRows.filter(row => {
          const teacherText = row.cells[2].textContent.toLowerCase();
          const levelText = row.cells[4].textContent.toLowerCase();
          const statusText = row.cells[5].textContent.toLowerCase().replace('hoạt động', 'hoạt động').replace('khóa', 'khóa');
          const createdDateText = row.cells[6].textContent;
          const nameText = row.cells[1].textContent.toLowerCase();

          const matchesTeacher = teacher === '' || teacherText.includes(teacher);
          const matchesLevel = level === '' || levelText.includes(level);
          const matchesStatus = status === '' || statusText.includes(status);
          const matchesDate = !createdDate || createdDateText === createdDate;
          const matchesName = !nameSearch || nameText.includes(nameSearch);

          return matchesTeacher && matchesLevel && matchesStatus && matchesDate && matchesName;
        });

        currentPage = 1; // Reset to first page on filter change
        updatePagination();
      }

      // Pagination button listeners
      document.getElementById('prevPage').addEventListener('click', () => {
        if (currentPage > 1) {
          currentPage--;
          updatePagination();
        }
      });

      document.getElementById('nextPage').addEventListener('click', () => {
        const totalRows = filteredRows.length || allRows.length;
        const totalPages = Math.ceil(totalRows / rowsPerPage);
        if (currentPage < totalPages) {
          currentPage++;
          updatePagination();
        }
      });

     
      // View course details modal logic
      document.querySelectorAll('.btn-view').forEach(button => {
        button.addEventListener('click', function () {
          const courseId = this.getAttribute('data-course-id');
          const courseName = this.getAttribute('data-course-name');
          const teacher = this.getAttribute('data-teacher');
          const students = this.getAttribute('data-students');
          const level = this.getAttribute('data-level');
          const status = this.getAttribute('data-status');
          const createdDate = this.getAttribute('data-created-date');
          const description = this.getAttribute('data-description');
          const duration = this.getAttribute('data-duration');
          const price = this.getAttribute('data-price');
          const discountCode = this.getAttribute('data-discount-code') || 'Không có';
          const discountPercent = this.getAttribute('data-discount-percent') || '0';

          document.getElementById('viewCourseId').textContent = courseId;
          document.getElementById('viewCourseName').textContent = courseName;
          document.getElementById('viewTeacher').textContent = teacher;
          document.getElementById('viewStudents').textContent = students;
          document.getElementById('viewLevel').textContent = level;
          document.getElementById('viewStatus').innerHTML = status === 'Hoạt Động' 
            ? '<span class="badge badge-active">Hoạt Động</span>' 
            : '<span class="badge badge-inactive">Khóa</span>';
          document.getElementById('viewCreatedDate').textContent = createdDate;
          document.getElementById('viewDescription').textContent = description || 'Không có mô tả';
          document.getElementById('viewDuration').textContent = duration || 'Không xác định';
          document.getElementById('viewPrice').textContent = Number(price).toLocaleString('vi-VN') + ' VND';
          document.getElementById('viewDiscountCode').innerHTML = discountCode !== 'Không có' 
            ? `<span class="badge badge-active">${discountCode}</span>` 
            : '<span class="badge badge-inactive">Không có</span>';
          document.getElementById('viewDiscountPercent').textContent = discountPercent + '%';
        });
      });

      // Edit course modal logic
      document.querySelectorAll('.btn-edit').forEach(button => {
        button.addEventListener('click', function () {
          const courseId = this.getAttribute('data-course-id');
          const courseName = this.getAttribute('data-course-name');
          const teacher = this.getAttribute('data-teacher');
          const level = this.getAttribute('data-level');
          const status = this.getAttribute('data-status');
          const description = this.getAttribute('data-description');
          const duration = this.getAttribute('data-duration');
          const price = this.getAttribute('data-price');
          const discountCode = this.getAttribute('data-discount-code') || '';
          const discountPercent = this.getAttribute('data-discount-percent') || '';

          document.getElementById('editCourseId').value = courseId;
          document.getElementById('editCourseName').value = courseName;
          document.getElementById('editTeacher').value = teacher;
          document.getElementById('editLevel').value = level;
          document.getElementById('editStatus').value = status;
          document.getElementById('editDescription').value = description;
          document.getElementById('editDuration').value = duration;
          document.getElementById('editPrice').value = price;
          document.getElementById('editDiscountCode').value = discountCode;
          document.getElementById('editDiscountPercent').value = discountPercent;
        });
      });

      // Delete course modal logic
      document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', function () {
          const courseId = this.getAttribute('data-course-id');
          const courseName = this.getAttribute('data-course-name');

          document.getElementById('deleteCourseId').textContent = courseId;
          document.getElementById('deleteCourseName').textContent = courseName;
          document.getElementById('deleteCourseIdInput').value = courseId;
        });
      });

      // Initial pagination setup
      updatePagination();
      