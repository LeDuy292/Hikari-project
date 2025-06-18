
      const quotes = [
        {
          japanese: "千里の道も一歩から",
          vietnamese: "Hành trình ngàn dặm bắt đầu từ một bước chân",
          romaji: "Senri no michi mo ippo kara",
        },
        {
          japanese: "継続は力なり",
          vietnamese: "Kiên trì là sức mạnh",
          romaji: "Keizoku wa chikara nari",
        },
        {
          japanese: "七転び八起き",
          vietnamese: "Ngã bảy lần, đứng dậy tám lần",
          romaji: "Nanakorobi yaoki",
        },
        {
          japanese: "学問に王道なし",
          vietnamese: "Không có con đường tắt đến tri thức",
          romaji: "Gakumon ni ōdō nashi",
        },
        {
          japanese: "一期一会",
          vietnamese: "Một lần gặp gỡ, một cơ hội duy nhất",
          romaji: "Ichigo ichie",
        },
      ];
      function changeQuote() {
        const q = quotes[Math.floor(Math.random() * quotes.length)];
        document.getElementById("quoteJapanese").textContent = q.japanese;
        document.getElementById("quoteRomaji").textContent = q.romaji;
        document.getElementById(
          "quoteVietnamese"
        ).textContent = `"${q.vietnamese}"`;
      }
      setInterval(changeQuote, 9000);
      changeQuote();
      function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const eye = document.getElementById(fieldId + "Eye");
        if (field.type === "password") {
          field.type = "text";
          eye.classList.remove("fa-eye");
          eye.classList.add("fa-eye-slash");
        } else {
          field.type = "password";
          eye.classList.remove("fa-eye-slash");
          eye.classList.add("fa-eye");
        }
      }