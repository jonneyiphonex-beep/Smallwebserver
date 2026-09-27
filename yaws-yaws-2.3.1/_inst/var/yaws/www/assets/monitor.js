const cpuValue = document.getElementById('cpuValue');
const cpuBar = document.getElementById('cpuBar');
const memoryValue = document.getElementById('memoryValue');
const memoryBar = document.getElementById('memoryBar');
const memoryDetail = document.getElementById('memoryDetail');
const diskRead = document.getElementById('diskRead');
const diskWrite = document.getElementById('diskWrite');
const diskDevices = document.getElementById('diskDevices');
const responseNs = document.getElementById('responseNs');
const sampleNs = document.getElementById('sampleNs');
const metricStatus = document.getElementById('metricStatus');

const numberFormat = new Intl.NumberFormat('en-US', { maximumFractionDigits: 1 });
let previousSample = null;

function formatBytes(bytes) {
  const units = ['B', 'KiB', 'MiB', 'GiB', 'TiB'];
  let value = bytes;
  let unit = 0;

  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit += 1;
  }

  return `${numberFormat.format(value)} ${units[unit]}`;
}

function sumDiskSectors(disks, key) {
  return disks.reduce((total, disk) => total + disk[key], 0);
}

function setMeter(valueElement, barElement, percentage) {
  const safePercentage = Math.max(0, Math.min(100, percentage));
  valueElement.textContent = numberFormat.format(safePercentage);
  barElement.style.width = `${safePercentage}%`;
  barElement.parentElement.setAttribute('aria-valuenow', safePercentage.toFixed(1));
}

function renderMetrics(metrics, requestTimeNs, sampleTime) {
  const disks = metrics.disks || [];
  const totalMemory = metrics.memory_total_bytes;
  const availableMemory = metrics.memory_available_bytes;
  const usedMemory = Math.max(0, totalMemory - availableMemory);
  const memoryPercentage = totalMemory > 0 ? (usedMemory / totalMemory) * 100 : 0;

  setMeter(memoryValue, memoryBar, memoryPercentage);
  memoryDetail.textContent = `${formatBytes(usedMemory)} مستخدمة من ${formatBytes(totalMemory)}`;
  responseNs.textContent = numberFormat.format(requestTimeNs);
  sampleNs.textContent = numberFormat.format(metrics.sample_ns);
  diskDevices.textContent = disks.length
    ? `الأقراص: ${disks.map((disk) => disk.name).join('، ')}`
    : 'لم يعثر النظام على أقراص قابلة للقراءة';

  if (previousSample) {
    const elapsedSeconds = (sampleTime - previousSample.time) / 1000;
    const totalDelta = metrics.cpu_total - previousSample.cpuTotal;
    const idleDelta = metrics.cpu_idle - previousSample.cpuIdle;
    const cpuPercentage = totalDelta > 0
      ? ((totalDelta - idleDelta) / totalDelta) * 100
      : 0;
    const readDelta = Math.max(0, sumDiskSectors(disks, 'sectors_read') - previousSample.readSectors);
    const writeDelta = Math.max(0, sumDiskSectors(disks, 'sectors_written') - previousSample.writeSectors);

    setMeter(cpuValue, cpuBar, cpuPercentage);
    diskRead.textContent = `${numberFormat.format((readDelta * 512) / elapsedSeconds / 1048576)} MiB/s`;
    diskWrite.textContent = `${numberFormat.format((writeDelta * 512) / elapsedSeconds / 1048576)} MiB/s`;
  }

  previousSample = {
    time: sampleTime,
    cpuTotal: metrics.cpu_total,
    cpuIdle: metrics.cpu_idle,
    readSectors: sumDiskSectors(disks, 'sectors_read'),
    writeSectors: sumDiskSectors(disks, 'sectors_written'),
  };
}

async function refreshMetrics() {
  const requestStarted = performance.now();

  try {
    const response = await fetch(`/metrics.yaws?ts=${Date.now()}`, { cache: 'no-store' });
    if (!response.ok) {
      throw new Error(`Metrics request failed: ${response.status}`);
    }

    const body = await response.text();
    const requestTimeNs = Math.round((performance.now() - requestStarted) * 1000000);
    const sampleTime = performance.now();
    const metrics = JSON.parse(body);
    renderMetrics(metrics, requestTimeNs, sampleTime);
    metricStatus.textContent = 'متصل · تحديث كل ثانية';
    metricStatus.classList.add('is-online');
  } catch {
    metricStatus.textContent = 'تعذر قراءة المؤشرات · أعد المحاولة تلقائيًا';
    metricStatus.classList.remove('is-online');
  }

  window.setTimeout(refreshMetrics, 1000);
}

refreshMetrics();