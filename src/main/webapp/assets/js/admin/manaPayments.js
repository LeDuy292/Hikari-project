/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
 
      // Pagination and filtering logic
      const rowsPerPage = 10;
      let currentPage = 1;
      let filteredRows = [];

      // Get all rows
      const allRows = Array.from(document.querySelectorAll('#paymentTableBody tr'));

      // Format number as VND
      function formatVND(amount) {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
      }

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
      document.querySelectorAll('#payerFilter, #courseFilter, #statusFilter, #paymentDateFilter, #minAmountFilter, #maxAmountFilter, #search').forEach(filter => {
        filter.addEventListener('change', applyFilters);
        filter.addEventListener('input', applyFilters);
      });

      function applyFilters() {
        const payer = document.getElementById('payerFilter').value.toLowerCase();
        const course = document.getElementById('courseFilter').value.toLowerCase();
        const status = document.getElementById('statusFilter').value.toLowerCase();
        const paymentDate = document.getElementById('paymentDateFilter').value;
        const minAmount = parseFloat(document.getElementById('minAmountFilter').value) || 0;
        const maxAmount = parseFloat(document.getElementById('maxAmountFilter').value) || Infinity;
        const search = document.getElementById('search').value.toLowerCase();

        filteredRows = allRows.filter(row => {
          const payerText = row.cells[2].textContent.toLowerCase();
          const courseText = row.cells[3].textContent.toLowerCase();
          const statusText = row.cells[5].textContent.toLowerCase();
          const paymentDateText = row.cells[6].textContent;
          const amountText = parseFloat(row.cells[4].textContent.replace(/,/g, '')) || 0;
          const idText = row.cells[0].textContent.toLowerCase();

          const matchesPayer = payer === '' || payerText.includes(payer);
          const matchesCourse = course === '' || courseText.includes(course);
          const matchesStatus = status === '' || statusText.includes(status);
          const matchesDate = !paymentDate || paymentDateText === paymentDate;
          const matchesAmount = amountText >= minAmount && amountText <= maxAmount;
          const matchesSearch = !search || idText.includes(search) || payerText.includes(search);

          return matchesPayer && matchesCourse && matchesStatus && matchesDate && matchesAmount && matchesSearch;
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

      // View payment details modal logic
      document.querySelectorAll('.btn-view').forEach(button => {
        button.addEventListener('click', function () {
          const paymentId = this.getAttribute('data-payment-id');
          const payer = this.getAttribute('data-payer');
          const course = this.getAttribute('data-course');
          const amount = parseFloat(this.getAttribute('data-amount'));
          const status = this.getAttribute('data-status');
          const paymentDate = this.getAttribute('data-payment-date');
          const paymentMethod = this.getAttribute('data-payment-method');

          document.getElementById('viewPaymentId').textContent = paymentId;
          document.getElementById('viewPayer').textContent = payer;
          document.getElementById('viewCourse').textContent = course;
          document.getElementById('viewAmount').textContent = formatVND(amount);
          document.getElementById('viewStatus').innerHTML = 
            status === 'Thành Công' ? '<span class="badge badge-success">Thành Công</span>' :
            status === 'Thất Bại' ? '<span class="badge badge-failed">Thất Bại</span>' :
            '<span class="badge badge-pending">Đang Chờ</span>';
          document.getElementById('viewPaymentDate').textContent = paymentDate;
          document.getElementById('viewPaymentMethod').textContent = paymentMethod;
        });
      });

      // Initial pagination setup
      updatePagination();
