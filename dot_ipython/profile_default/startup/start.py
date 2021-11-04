import re
import os
import sys
import collections
import functools
import json
import requests
import typing as t

import importlib
import logging
import types

import bentoml

logger = logging.getLogger(__name__)


class LazyLoader(types.ModuleType):
    """
    LazyLoader module borrowed from Tensorflow
     https://github.com/tensorflow/tensorflow/blob/v2.2.0/tensorflow/python/util/lazy_loader.py

    Lazily import a module, mainly to avoid pulling in large dependencies.
     `contrib`, and `ffmpeg` are examples of modules that are large and not always
     needed, and this allows them to only be loaded when they are used.
    """

    def __init__(
        self,
        local_name: str,
        parent_module_globals: dict,
        name: str,
        warning: t.Optional[str] = None,
    ):
        self._local_name = local_name
        self._parent_module_globals = parent_module_globals
        self._warning = warning
        self._module: t.Optional[types.ModuleType] = None

        super(LazyLoader, self).__init__(str(name))

    def _load(self) -> types.ModuleType:
        """Load the module and insert it into the parent's globals."""
        # Import the target module and insert it into the parent's namespace
        try:
            module = importlib.import_module(self.__name__)
            self._parent_module_globals[self._local_name] = module
            # The additional add to sys.modules ensures library is actually loaded.
            sys.modules[self._local_name] = module
        except ModuleNotFoundError as e:
            raise e

        # Emit a warning if one was specified
        if self._warning:
            logger.warning(self._warning)
            # Make sure to only warn once.
            self._warning = None

        # Update this object's dict so that if someone keeps a reference to the
        #   LazyLoader, lookups are efficient (__getattr__ is only called on lookups
        #   that fail).
        self.__dict__.update(module.__dict__)

        return module

    def __getattr__(self, item):  # type: ignore[no-untyped-def]
        if self._module is None:
            self._module = self._load()
        return getattr(self._module, item)

    def __dir__(self) -> t.List[str]:
        if self._module is None:
            self._module = self._load()
        return dir(self._module)


matplotlib = LazyLoader("matplotlib", globals(), "matplotlib")
plt = LazyLoader("plt", globals(), "matplotlib.pyplot")
pd = LazyLoader("pd", globals(), "pandas")
np = LazyLoader("np", globals(), "numpy")
sklearn = LazyLoader("sklearn", globals(), "sklearn")
tf = LazyLoader("tf", globals(), "tensorflow")
torch = LazyLoader("torch", globals(), "torch")
F = LazyLoader("F", globals(), "torch.nn.functional")
transformers = LazyLoader("transformers", globals(), "transformers")
jax = LazyLoader("jax", globals(), "jax")
jnp = LazyLoader("jnp", globals(), "jnp")
flax = LazyLoader("flax", globals(), "flax")
linen = LazyLoader("linen", globals(), "flax.linen")
sns = LazyLoader("sns", globals(), "seaborn")

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


# Pandas options
# pd.options.display.max_columns = 30
# pd.options.display.max_rows = 30
# transformers.logging.set_verbosity_debug()
