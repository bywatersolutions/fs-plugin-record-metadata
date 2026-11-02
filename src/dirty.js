let check = null;

export function setDirtyCheck(fn) {
  check = fn;
  return () => {
    if (check === fn) check = null;
  };
}

export const isDirty = () => (check ? check() : false);
