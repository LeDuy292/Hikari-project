/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
 
      // Mock review details data
      const reviewDetails = {
        REV001: {
          pros: ["Giảng viên nhiệt tình", "Tài liệu chi tiết", "Hỗ trợ ngoài giờ học"],
          cons: [],
          suggestions: ["Thêm bài tập thực hành"],
          completionDate: "2025-04-28",
          courseDuration: "3 tháng",
          progressPercentage: 100,
          instructorResponse: "Cảm ơn bạn đã đánh giá cao! Tôi sẽ bổ sung thêm bài tập trong các khóa sau.",
          enrollmentDate: "2024-12-01",
          totalCourses: 3,
          coursesTaught: 5,
          overallRating: 4.8,
          instructorAverageRating: 4.8,
          totalReviews: 10,
          ratingTrend: "tăng từ 4.7",
          reviewWeight: "1/10"
        },
        REV002: {
          pros: ["Phương pháp giảng dạy sáng tạo", "Tương tác tốt với học viên"],
          cons: ["Bài tập còn ít"],
          suggestions: ["Cung cấp thêm tài liệu thực hành"],
          completionDate: "2025-04-29",
          courseDuration: "4 tháng",
          progressPercentage: 95,
          instructorResponse: "Cảm ơn góp ý, tôi sẽ tăng cường bài tập trong tương lai!",
          enrollmentDate: "2024-11-15",
          totalCourses: 2,
          coursesTaught: 4,
          overallRating: 4.2,
          instructorAverageRating: 4.2,
          totalReviews: 8,
          ratingTrend: "ổn định",
          reviewWeight: "1/8"
        },
        REV003: {
          pros: ["Kiến thức chuyên môn tốt"],
          cons: ["Tốc độ giảng bài nhanh", "Ít thời gian thực hành"],
          suggestions: ["Giảm tốc độ giảng dạy", "Tăng bài tập thực hành"],
          completionDate: "2025-04-30",
          courseDuration: "5 tháng",
          progressPercentage: 90,
          instructorResponse: "",
          enrollmentDate: "2024-10-01",
          totalCourses: 4,
          coursesTaught: 6,
          overallRating: 3.9,
          instructorAverageRating: 3.9,
          totalReviews: 12,
          ratingTrend: "giảm từ 4.0",
          reviewWeight: "1/12"
        },
        REV004: {
          pros: ["Ví dụ thực tế phong phú", "Giảng viên tận tâm"],
          cons: [],
          suggestions: ["Thêm video minh họa"],
          completionDate: "2025-05-01",
          courseDuration: "2 tháng",
          progressPercentage: 100,
          instructorResponse: "Cảm ơn bạn! Tôi sẽ xem xét thêm video minh họa.",
          enrollmentDate: "2024-12-01",
          totalCourses: 3,
          coursesTaught: 5,
          overallRating: 4.8,
          instructorAverageRating: 4.8,
          totalReviews: 10,
          ratingTrend: "tăng từ 4.7",
          reviewWeight: "1/10"
        },
        REV005: {
          pros: ["Giảng viên thân thiện", "Nội dung dễ hiểu"],
          cons: ["Lịch học kém linh hoạt"],
          suggestions: ["Tăng tính linh hoạt lịch học"],
          completionDate: "2025-05-02",
          courseDuration: "3 tháng",
          progressPercentage: 98,
          instructorResponse: "Cảm ơn góp ý, tôi sẽ đề xuất điều chỉnh lịch học.",
          enrollmentDate: "2024-11-15",
          totalCourses: 2,
          coursesTaught: 4,
          overallRating: 4.2,
          instructorAverageRating: 4.2,
          totalReviews: 8,
          ratingTrend: "ổn định",
          reviewWeight: "1/8"
        },
        REV006: {
          pros: ["Nội dung bài học phù hợp"],
          cons: ["Thiếu tài liệu bổ sung"],
          suggestions: ["Cung cấp thêm tài liệu tham khảo"],
          completionDate: "2025-05-03",
          courseDuration: "2.5 tháng",
          progressPercentage: 92,
          instructorResponse: "",
          enrollmentDate: "2024-10-01",
          totalCourses: 4,
          coursesTaught: 6,
          overallRating: 3.9,
          instructorAverageRating: 3.9,
          totalReviews: 12,
          ratingTrend: "giảm từ 4.0",
          reviewWeight: "1/12"
        },
        REV007: {
          pros: ["Giảng viên chuyên nghiệp", "Hỗ trợ tận tình"],
          cons: [],
          suggestions: ["Thêm bài kiểm tra định kỳ"],
          completionDate: "2025-05-04",
          courseDuration: "4 tháng",
          progressPercentage: 100,
          instructorResponse: "Cảm ơn bạn! Tôi sẽ cân nhắc thêm bài kiểm tra.",
          enrollmentDate: "2024-12-01",
          totalCourses: 3,
          coursesTaught: 5,
          overallRating: 4.8,
          instructorAverageRating: 4.8,
          totalReviews: 10,
          ratingTrend: "tăng từ 4.7",
          reviewWeight: "1/10"
        },
        REV008: {
          pros: [],
          cons: ["Cách truyền đạt khó hiểu", "Nội dung chưa hấp dẫn"],
          suggestions: ["Cải thiện cách giảng dạy", "Thêm ví dụ thực tế"],
          completionDate: "2025-05-05",
          courseDuration: "3 tháng",
          progressPercentage: 85,
          instructorResponse: "",
          enrollmentDate: "2024-11-15",
          totalCourses: 2,
          coursesTaught: 4,
          overallRating: 4.2,
          instructorAverageRating: 4.2,
          totalReviews: 8,
          ratingTrend: "ổn định",
          reviewWeight: "1/8"
        },
        REV009: {
          pros: ["Kiến thức sâu rộng", "Giảng viên nhiệt tình"],
          cons: ["Bài giảng thiếu logic"],
          suggestions: ["Tổ chức bài giảng rõ ràng hơn"],
          completionDate: "2025-05-06",
          courseDuration: "3.5 tháng",
          progressPercentage: 95,
          instructorResponse: "Cảm ơn góp ý, tôi sẽ cải thiện cấu trúc bài giảng.",
          enrollmentDate: "2024-10-01",
          totalCourses: 4,
          coursesTaught: 6,
          overallRating: 3.9,
          instructorAverageRating: 3.9,
          totalReviews: 12,
          ratingTrend: "giảm từ 4.0",
          reviewWeight: "1/12"
        },
        REV010: {
          pros: ["Giảng viên tận tâm", "Nội dung thực tế"],
          cons: [],
          suggestions: ["Thêm bài tập nhóm"],
          completionDate: "2025-05-07",
          courseDuration: "4 tháng",
          progressPercentage: 100,
          instructorResponse: "Cảm ơn bạn! Tôi sẽ xem xét thêm bài tập nhóm.",
          enrollmentDate: "2024-12-01",
          totalCourses: 3,
          coursesTaught: 5,
          overallRating: 4.8,
          instructorAverageRating: 4.8,
          totalReviews: 10,
          ratingTrend: "tăng từ 4.7",
          reviewWeight: "1/10"
        }
      };

      // Function to generate star rating
      function generateStars(rating) {
        const fullStar = '★';
        const emptyStar = '☆';
        return fullStar.repeat(rating) + emptyStar.repeat(5 - rating);
      }

      // Function to show review details in view modal
      function showReviewDetails(reviewId) {
        const row = document.querySelector(`tr[data-review-id="${reviewId}"]`);
        const details = reviewDetails[reviewId];

        // Thông Tin Đánh Giá
        document.getElementById('modalReviewId').textContent = row.cells[0].textContent;
        document.getElementById('modalReviewer').textContent = row.cells[2].textContent;
        document.getElementById('modalReviewerAvatar').src = "img/dashborad/defaultAvatar.png";
        document.getElementById('modalInstructor').textContent = row.cells[3].textContent;
        document.getElementById('modalCourse').textContent = row.cells[4].textContent;
        document.getElementById('modalRating').innerHTML = row.cells[5].innerHTML;
        document.getElementById('modalReviewDate').textContent = row.cells[6].textContent;

        // Lời Nhận Xét
        const prosList = document.getElementById('modalPros');
        const consList = document.getElementById('modalCons');
        const suggestionsList = document.getElementById('modalSuggestions');
        prosList.innerHTML = details.pros.length ? details.pros.map(item => `<li>${item}</li>`).join('') : '<li>Không có</li>';
        consList.innerHTML = details.cons.length ? details.cons.map(item => `<li>${item}</li>`).join('') : '<li>Không có</li>';
        suggestionsList.innerHTML = details.suggestions.length ? details.suggestions.map(item => `<li>${item}</li>`).join('') : '<li>Không có</li>';
        document.getElementById('modalInstructorResponse').textContent = details.instructorResponse || "Không có phản hồi";

        // Ý Nghĩa Đánh Giá
        const ratingMatch = row.cells[5].textContent.match(/\((\d)\)/);
        const ratingValue = ratingMatch ? parseInt(ratingMatch[1]) : 0;
        let impactMessage;
        if (ratingValue >= 4) {
          impactMessage = "Đánh giá cao này nâng cao uy tín của giảng viên, giúp thu hút thêm học viên trên nền tảng HIKARI.";
        } else if (ratingValue === 3) {
          impactMessage = "Đánh giá trung bình này cho thấy giảng viên cần cải thiện để đáp ứng tốt hơn kỳ vọng của học viên.";
        } else {
          impactMessage = "Đánh giá thấp này có thể ảnh hưởng đến uy tín của giảng viên, cần xem xét cải thiện chất lượng giảng dạy.";
        }
        document.getElementById('modalSignificance').innerHTML = `
          Điểm <strong>${ratingValue}/5</strong> từ đánh giá này (${details.reviewWeight} đánh giá) góp phần vào đánh giá trung bình của giảng viên là <strong>${details.instructorAverageRating}/5</strong> (dựa trên ${details.totalReviews} đánh giá). 
          Đánh giá trung bình ${details.ratingTrend}.<br/>
          ${impactMessage}
        `;

        // Thông Tin Bổ Sung
        document.getElementById('modalCompletionDate').textContent = details.completionDate;
        document.getElementById('modalCourseDuration').textContent = details.courseDuration;
        const progressBar = document.getElementById('modalProgressBar');
        progressBar.style.width = `${details.progressPercentage}%`;
        progressBar.setAttribute('aria-valuenow', details.progressPercentage);
        progressBar.textContent = `${details.progressPercentage}%`;

        // Chi Tiết Học Viên
        document.getElementById('modalEnrollmentDate').textContent = details.enrollmentDate;
        document.getElementById('modalTotalCourses').textContent = details.totalCourses;

        // Chi Tiết Giảng Viên
        document.getElementById('modalCoursesTaught').textContent = details.coursesTaught;
        document.getElementById('modalOverallRating').textContent = `${details.overallRating}/5`;
      }

      // Function to populate edit review modal
      function populateEditReviewModal(reviewId) {
        const row = document.querySelector(`tr[data-review-id="${reviewId}"]`);
        const details = reviewDetails[reviewId];

        document.getElementById('editReviewId').value = row.cells[0].textContent;
        document.getElementById('editReviewer').value = row.cells[2].textContent;
        document.getElementById('editInstructor').value = row.cells[3].textContent;
        document.getElementById('editCourse').value = row.cells[4].textContent;
        const ratingMatch = row.cells[5].textContent.match(/\((\d)\)/);
        document.getElementById('editRating').value = ratingMatch ? ratingMatch[1] : '';
        document.getElementById('editReviewDate').value = row.cells[6].textContent;
        document.getElementById('editPros').value = details.pros.join('\n');
        document.getElementById('editCons').value = details.cons.join('\n');
        document.getElementById('editSuggestions').value = details.suggestions.join('\n');
        document.getElementById('editInstructorResponse').value = details.instructorResponse;
      }

      // Function to populate delete review modal
      function populateDeleteReviewModal(reviewId, reviewer) {
        document.getElementById('deleteReviewId').textContent = reviewId;
        document.getElementById('deleteReviewer').textContent = reviewer;
        document.getElementById('deleteReviewIdInput').value = reviewId;
      }

      // Add event listeners to buttons
      document.querySelectorAll('.btn-view').forEach(button => {
        button.addEventListener('click', () => {
          const reviewId = button.getAttribute('data-review-id');
          showReviewDetails(reviewId);
        });
      });

      document.querySelectorAll('.btn-edit').forEach(button => {
        button.addEventListener('click', () => {
          const reviewId = button.getAttribute('data-review-id');
          populateEditReviewModal(reviewId);
        });
      });

      document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', () => {
          const reviewId = button.getAttribute('data-review-id');
          const reviewer = button.getAttribute('data-reviewer');
          populateDeleteReviewModal(reviewId, reviewer);
        });
      });

      // Pagination and filtering logic
      const rowsPerPage = 10;
      let currentPage = 1;
      let filteredRows = [];

      // Get all rows
      const allRows = Array.from(document.querySelectorAll('#reviewTableBody tr'));

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
      document.querySelectorAll('#reviewerFilter, #instructorFilter, #courseFilter, #ratingFilter, #reviewDateFilter, #search').forEach(filter => {
        filter.addEventListener('change', applyFilters);
        filter.addEventListener('input', applyFilters);
      });

      function applyFilters() {
        const reviewer = document.getElementById('reviewerFilter').value.toLowerCase();
        const instructor = document.getElementById('instructorFilter').value.toLowerCase();
        const course = document.getElementById('courseFilter').value.toLowerCase();
        const rating = document.getElementById('ratingFilter').value;
        const reviewDate = document.getElementById('reviewDateFilter').value;
        const search = document.getElementById('search').value.toLowerCase();

        filteredRows = allRows.filter(row => {
          const reviewerText = row.cells[2].textContent.toLowerCase();
          const instructorText = row.cells[3].textContent.toLowerCase();
          const courseText = row.cells[4].textContent.toLowerCase();
          const ratingText = row.cells[5].textContent.match(/\d/) ? row.cells[5].textContent.match(/\d/)[0] : '';
          const reviewDateText = row.cells[6].textContent;
          const idText = row.cells[0].textContent.toLowerCase();

          const matchesReviewer = reviewer === '' || reviewerText.includes(reviewer);
          const matchesInstructor = instructor === '' || instructorText.includes(instructor);
          const matchesCourse = course === '' || courseText.includes(course);
          const matchesRating = rating === '' || ratingText === rating;
          const matchesDate = !reviewDate || reviewDateText === reviewDate;
          const matchesSearch = !search || idText.includes(search) || reviewerText.includes(search);

          return matchesReviewer && matchesInstructor && matchesCourse && matchesRating && matchesDate && matchesSearch;
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

      // Initial pagination setup
      updatePagination();