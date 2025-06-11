    document.addEventListener('DOMContentLoaded', () => {
        const testList = document.getElementById('testList');
        const questionDetail = document.getElementById('questionDetail');
        const headerTitle = document.getElementById('headerTitle');
        const testTitle = document.getElementById('testTitle');
        const backToTests = document.getElementById('backToTests');
        const questionList = document.getElementById('questionList');
        const totalQuestions = document.getElementById('totalQuestions');
        const multipleChoiceCountDisplay = document.getElementById('multipleChoiceCountDisplay');
        const essayCountDisplay = document.getElementById('essayCountDisplay');
        const prevPageBtn = document.getElementById('prevPageBtn');
        const nextPageBtn = document.getElementById('nextPageBtn');
        const paginationDots = document.getElementById('paginationDots');
        const questionContent = document.getElementById('questionContent');
        const questionOptions = document.getElementById('questionOptions');
        const questionAnswer = document.getElementById('questionAnswer');
        const correctAnswerText = document.getElementById('correctAnswerText');
        const editQuestionBtn = document.getElementById('editQuestionBtn');
        const editQuestionForm = document.getElementById('editQuestionForm');
        const editQuestionType = document.getElementById('editQuestionType');
        const editOptionsContainer = document.getElementById('editOptionsContainer');
        const editAnswerContainer = document.getElementById('editAnswerContainer');
        const editCorrectAnswerText = document.getElementById('editCorrectAnswerText');
        const cancelEditQuestionBtn = document.getElementById('cancelEditQuestionBtn');
        const saveEditBtn = document.getElementById('saveEditBtn');
        const setTimeBtn = document.getElementById('setTimeBtn');
        const setTimeForm = document.getElementById('setTimeForm');
        const testDurationInput = document.getElementById('testDuration');
        const saveTimeBtn = document.getElementById('saveTimeBtn');
        const cancelTimeBtn = document.getElementById('cancelTimeBtn');
        const setQuestionsBtn = document.getElementById('setQuestionsBtn');
        const setQuestionsForm = document.getElementById('setQuestionsForm');
        const totalQuestionsInput = document.getElementById('totalQuestionsInput');
        const saveQuestionsBtn = document.getElementById('saveQuestionsBtn');
        const cancelQuestionsBtn = document.getElementById('cancelQuestionsBtn');

        let currentTest = '';
        let questionsByTest = {};

        const tests = {
          1: { title: "Bài Test N1", duration: 60 },
          2: { title: "Bài Test N2", duration: 50 },
          3: { title: "Bài Test N3", duration: 40 }
        };

        function generateDefaultQuestions(testId, total) {
          const questions = [];
          for (let i = 0; i < total; i++) {
            questions.push({
              id: i + 1,
              type: "multiple-choice",
              content: `Câu hỏi ${i + 1}: Đây là câu hỏi trắc nghiệm số ${i + 1}. Hãy chọn đáp án đúng.`,
              options: [
                `A. Đáp án A cho câu ${i + 1}`,
                `B. Đáp án B cho câu ${i + 1} (Đáp án đúng)`,
                `C. Đáp án C cho câu ${i + 1}`,
                `D. Đáp án D cho câu ${i + 1}`
              ],
              correctAnswer: 1,
              essayAnswer: null
            });
          }
          return questions;
        }

        function updateQuestionList(testId) {
          const questions = questionsByTest[testId] || [];
          questionList.innerHTML = questions.map(question => `
            <div class="question-item ${question.id === 1 ? 'active' : ''}" data-question-id="${question.id}">
              ${question.id}
            </div>
          `).join('');

          const total = questions.length;
          const multipleChoice = questions.filter(q => q.type === "multiple-choice").length;
          const essay = questions.filter(q => q.type === "text").length;

          totalQuestions.textContent = `Tổng: ${total} câu`;
          multipleChoiceCountDisplay.textContent = `Trắc nghiệm: ${multipleChoice} câu`;
          essayCountDisplay.textContent = `Tự luận: ${essay} câu`;
        }

        document.querySelectorAll('.test-card').forEach(card => {
          card.addEventListener('click', () => {
            const testId = card.getAttribute('data-test-id');
            const testTitleText = card.querySelector('.test-title').textContent;
            currentTest = testId;
            testList.style.display = 'none';
            questionDetail.style.display = 'block';
            headerTitle.textContent = `Câu Hỏi - ${testTitleText}`;
            testTitle.textContent = `${testTitleText} (${tests[testId].duration} phút)`;

            // Initialize with default values if not set
            if (!questionsByTest[testId]) {
              questionsByTest[testId] = generateDefaultQuestions(testId, 10); // Default: 10 questions, all MC
            }
            updateQuestionList(testId);

            const activeQuestion = questionsByTest[testId].find(q => q.id === 1) || questionsByTest[testId][0];
            displayQuestion(activeQuestion);
            editQuestionForm.style.display = 'none';
            editQuestionBtn.style.display = 'block';
            setTimeForm.style.display = 'none';
            setQuestionsForm.style.display = 'none';
          });
        });

        backToTests.addEventListener('click', (e) => {
          e.preventDefault();
          testList.style.display = 'block';
          questionDetail.style.display = 'none';
          headerTitle.textContent = 'Quản Lý Bài Test';
        });

        questionList.addEventListener('click', (e) => {
          const questionItem = e.target.closest('.question-item');
          if (!questionItem) return;
          const questionId = parseInt(questionItem.getAttribute('data-question-id'));
          const question = questionsByTest[currentTest].find(q => q.id === questionId);
          if (!question) return;

          questionList.querySelectorAll('.question-item').forEach(item => item.classList.remove('active'));
          questionItem.classList.add('active');

          displayQuestion(question);
        });

        function displayQuestion(question) {
          document.querySelector('#questionContent h3').textContent = `Câu hỏi ${question.id}`;
          document.querySelector('#questionContent .question-meta span').innerHTML = `<i class="fas fa-question-circle"></i> ${question.type === 'multiple-choice' ? 'Trắc nghiệm' : 'Tự luận'}`;
          document.querySelector('#questionContent p').textContent = question.content;
          questionOptions.innerHTML = '';
          questionAnswer.style.display = 'none';
          correctAnswerText.value = '';

          if (question.type === 'multiple-choice') {
            questionOptions.style.display = 'block';
            question.options.forEach((option, index) => {
              const optionItem = document.createElement('div');
              optionItem.classList.add('option-item');
              if (index === question.correctAnswer) optionItem.classList.add('correct');
              optionItem.innerHTML = `
                <input type="radio" name="question${question.id}" disabled ${index === question.correctAnswer ? 'checked' : ''} />
                ${option}
              `;
              questionOptions.appendChild(optionItem);
            });
          } else if (question.type === 'text') {
            questionAnswer.style.display = 'block';
            correctAnswerText.value = question.essayAnswer || '';
          }
        }

        editQuestionBtn.addEventListener('click', () => {
          editQuestionForm.style.display = 'block';
          editQuestionBtn.style.display = 'none';
          const activeQuestion = questionsByTest[currentTest].find(q => q.id === parseInt(document.querySelector('.question-item.active')?.getAttribute('data-question-id')));
          if (activeQuestion) {
            document.getElementById('editQuestionText').value = activeQuestion.content;
            editQuestionType.value = activeQuestion.type;
            editOptionsContainer.style.display = activeQuestion.type === 'multiple-choice' ? 'block' : 'none';
            editAnswerContainer.style.display = activeQuestion.type === 'text' ? 'block' : 'none';
            if (activeQuestion.type === 'multiple-choice') {
              const optionInputs = editOptionsContainer.querySelectorAll('input[type="text"]');
              const correctRadios = editOptionsContainer.querySelectorAll('input[type="radio"]');
              activeQuestion.options.forEach((option, index) => {
                optionInputs[index].value = option;
              });
              correctRadios.forEach((radio, index) => {
                radio.checked = index === activeQuestion.correctAnswer;
              });
            } else {
              editCorrectAnswerText.value = activeQuestion.essayAnswer || '';
            }
          }
        });

        editQuestionType.addEventListener('change', () => {
          editOptionsContainer.style.display = editQuestionType.value === 'multiple-choice' ? 'block' : 'none';
          editAnswerContainer.style.display = editQuestionType.value === 'text' ? 'block' : 'none';
        });

        cancelEditQuestionBtn.addEventListener('click', () => {
          editQuestionForm.style.display = 'none';
          editQuestionBtn.style.display = 'block';
        });

        saveEditBtn.addEventListener('click', () => {
          const activeQuestion = questionsByTest[currentTest].find(q => q.id === parseInt(document.querySelector('.question-item.active')?.getAttribute('data-question-id')));
          if (activeQuestion) {
            activeQuestion.content = document.getElementById('editQuestionText').value;
            activeQuestion.type = editQuestionType.value;
            if (activeQuestion.type === 'multiple-choice') {
              const optionInputs = editOptionsContainer.querySelectorAll('input[type="text"]');
              const correctRadios = editOptionsContainer.querySelectorAll('input[type="radio"]');
              activeQuestion.options = Array.from(optionInputs).map(input => input.value);
              activeQuestion.correctAnswer = Array.from(correctRadios).findIndex(radio => radio.checked);
              activeQuestion.essayAnswer = null;
            } else {
              activeQuestion.essayAnswer = editCorrectAnswerText.value;
              activeQuestion.options = [];
              activeQuestion.correctAnswer = null;
            }
            displayQuestion(activeQuestion);
            editQuestionForm.style.display = 'none';
            editQuestionBtn.style.display = 'block';
            updateQuestionList(currentTest); // Update stats after type change
          }
        });

        setTimeBtn.addEventListener('click', () => {
          setTimeForm.style.display = 'block';
          testDurationInput.value = tests[currentTest].duration;
          setQuestionsForm.style.display = 'none';
        });

        saveTimeBtn.addEventListener('click', () => {
          const duration = parseInt(testDurationInput.value);
          if (!duration || duration < 1) {
            alert('Vui lòng nhập thời gian hợp lệ (ít nhất 1 phút)!');
            return;
          }
          tests[currentTest].duration = duration;
          testTitle.textContent = `${tests[currentTest].title} (${duration} phút)`;
          setTimeForm.style.display = 'none';
          document.querySelector(`.test-card[data-test-id="${currentTest}"] .test-info`).innerHTML = `<i class="fas fa-question-circle"></i> ${questionsByTest[currentTest].length} câu hỏi | ${duration} phút`;
        });

        cancelTimeBtn.addEventListener('click', () => {
          setTimeForm.style.display = 'none';
        });

        setQuestionsBtn.addEventListener('click', () => {
          setQuestionsForm.style.display = 'block';
          setTimeForm.style.display = 'none';
          const questions = questionsByTest[currentTest] || [];
          totalQuestionsInput.value = questions.length || '';
        });

        saveQuestionsBtn.addEventListener('click', () => {
          const total = parseInt(totalQuestionsInput.value);

          if (!total || total < 1 || total > 100) {
            alert('Vui lòng nhập tổng số câu hỏi hợp lệ (1-100)!');
            return;
          }

          questionsByTest[currentTest] = generateDefaultQuestions(currentTest, total);
          updateQuestionList(currentTest);

          // Update test info
          document.querySelector(`.test-card[data-test-id="${currentTest}"] .test-info`).innerHTML = `<i class="fas fa-question-circle"></i> ${total} câu hỏi | ${tests[currentTest].duration} phút`;

          setQuestionsForm.style.display = 'none';
        });

        cancelQuestionsBtn.addEventListener('click', () => {
          setQuestionsForm.style.display = 'none';
        });
      });