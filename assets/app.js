(() => {
  'use strict';

  const config = window.SHUNLI_AI_CONFIG;
  const worksGrid = document.querySelector('#works-grid');
  const modalRoot = document.querySelector('#work-modal-root');
  const status = document.querySelector('#contact-status');

  const setText = (element, value) => { element.textContent = value || ''; return element; };
  const validWork = work => work && !work.placeholder && /^[\w-]{6,}$/.test(work.videoId || '') && /^https:\/\/www\.youtube\.com\//.test(work.youtubeUrl || '');

  const closeWorkModal = () => {
    const modal = modalRoot?.querySelector('.work-modal');
    if (!modal) return;
    modal.querySelector('iframe')?.removeAttribute('src');
    modal.remove();
    document.body.classList.remove('modal-open');
    document.getElementById(modal.dataset.trigger)?.focus();
  };

  const openWorkModal = (work, trigger) => {
    if (!modalRoot || !validWork(work)) return;
    closeWorkModal();
    const modal = document.createElement('div');
    modal.className = 'work-modal';
    modal.dataset.trigger = trigger.id;
    modal.setAttribute('role', 'dialog');
    modal.setAttribute('aria-modal', 'true');
    const panel = document.createElement('div');
    panel.className = 'modal-panel';
    const header = document.createElement('div');
    header.className = 'modal-header';
    const title = document.createElement('h2');
    setText(title, work.title);
    const close = document.createElement('button');
    close.type = 'button'; close.className = 'modal-close'; close.setAttribute('aria-label', '關閉影片'); close.textContent = '×';
    const player = document.createElement('div');
    player.className = 'modal-player';
    const iframe = document.createElement('iframe');
    iframe.src = `https://www.youtube.com/embed/${encodeURIComponent(work.videoId)}?autoplay=1&rel=0`;
    iframe.title = work.title;
    iframe.loading = 'eager';
    iframe.allow = 'accelerometer; autoplay; encrypted-media; picture-in-picture';
    iframe.allowFullscreen = true;
    player.append(iframe); header.append(title, close); panel.append(header, player); modal.append(panel); modalRoot.append(modal);
    document.body.classList.add('modal-open'); close.addEventListener('click', closeWorkModal);
    modal.addEventListener('click', event => { if (event.target === modal) closeWorkModal(); });
    close.focus();
  };

  const renderWorks = works => {
    if (!worksGrid) return;
    worksGrid.replaceChildren();
    works.forEach((work, index) => {
      const card = document.createElement('article');
      card.className = 'work-card';
      const media = document.createElement('div'); media.className = 'work-media';
      if (work.thumbnail) { const image = document.createElement('img'); image.src = work.thumbnail; image.alt = `${work.title}縮圖`; image.loading = 'lazy'; media.append(image); }
      else { const placeholder = document.createElement('span'); placeholder.className = 'case-placeholder'; placeholder.textContent = `CASE ${String(index + 1).padStart(2, '0')}`; media.append(placeholder); }
      const body = document.createElement('div'); body.className = 'work-body';
      const industry = document.createElement('p'); industry.className = 'card-label'; setText(industry, work.industry);
      const heading = document.createElement('h3'); setText(heading, work.title);
      const need = document.createElement('p'); setText(need, `需求｜${work.need}`);
      const solution = document.createElement('p'); setText(solution, `AI 解法｜${work.solution}`);
      const description = document.createElement('p'); description.className = 'case-description'; setText(description, work.description);
      const meta = document.createElement('dl'); meta.className = 'case-meta';
      const servicesTerm = document.createElement('dt'); servicesTerm.textContent = '服務';
      const servicesValue = document.createElement('dd'); setText(servicesValue, (work.services || []).join('・'));
      const platformsTerm = document.createElement('dt'); platformsTerm.textContent = '適用平台';
      const platformsValue = document.createElement('dd'); setText(platformsValue, (work.platforms || []).join('・'));
      meta.append(servicesTerm, servicesValue, platformsTerm, platformsValue);
      body.append(industry, heading, need, solution, description, meta);
      if (validWork(work)) { const play = document.createElement('button'); play.type = 'button'; play.id = `work-play-${index + 1}`; play.className = 'text-button'; play.textContent = '查看影片'; play.addEventListener('click', () => openWorkModal(work, play)); body.append(play); }
      else { const note = document.createElement('span'); note.className = 'placeholder-note'; note.textContent = '案例素材準備中'; body.append(note); }
      card.append(media, body); worksGrid.append(card);
    });
  };

  document.addEventListener('keydown', event => { if (event.key === 'Escape') closeWorkModal(); });
  const menu = document.querySelector('.menu-toggle'); const nav = document.querySelector('#site-nav');
  menu?.addEventListener('click', () => { const open = nav.classList.toggle('is-open'); menu.setAttribute('aria-expanded', String(open)); });
  nav?.querySelectorAll('a').forEach(link => link.addEventListener('click', () => { nav.classList.remove('is-open'); menu?.setAttribute('aria-expanded', 'false'); }));
  document.querySelectorAll('[data-contact-action]').forEach(link => link.addEventListener('click', event => {
    const url = link.dataset.contactAction === 'line' ? config.LINE_URL : (config.CONSULT_URL || config.GOOGLE_FORM_URL);
    if (!url) { event.preventDefault(); status.textContent = '聯絡方式準備中，請稍後再試。'; return; }
    link.href = url; link.target = '_blank'; link.rel = 'noopener noreferrer';
  }));
  renderWorks(config?.WORKS || []);
  window.ShunliAIApp = Object.freeze({ renderWorks });
})();
